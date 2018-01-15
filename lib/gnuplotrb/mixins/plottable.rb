module GnuplotRB
  ##
  # This module contains methods that should be mixed into
  # plottable classes. It includes OptionHandling and
  # implements several plotting methods.
  module Plottable
    include OptionHandling

    ##
    # @private
    # You should implement #plot in classes that are Plottable
    def plot(*_)
      fail NotImplementedError, 'You should implement #plot in classes that are Plottable!'
    end

    ##
    # In this gem #method_missing is used both to handle
    # options and to handle plotting to specific terminal.
    #
    # == Options handling
    # === Overview
    # You may set options using #option_name(option_value) method.
    # A new object will be constructed with selected option set.
    # And finally you can get current value of any option using
    # #options_name without arguments.
    # === Arguments
    # * *option_value* - value to set an option. If none given
    #   method will just return current option's value
    # === Examples
    #   plot = Splot.new
    #   new_plot = plot.title('Awesome plot')
    #   plot.title #=> nil
    #   new_plot.title #=> 'Awesome plot'
    #
    # == Plotting to specific term
    # === Overview
    # Gnuplot offers possibility to output graphics to many image formats.
    # The easiest way to to so is to use #to_<plot_name> methods.
    # === Arguments
    # * *options* - set of options related to terminal (size, font etc).
    #   Be careful, some terminals have their own specific options.
    # === Examples
    #   # font options specific for png term
    #   multiplot.to_png('./result.png', size: [300, 500], font: ['arial', 12])
    #   # font options specific for svg term
    #   content = multiplot.to_svg(size: [100, 100], fname: 'Arial', fsize: 12)
    def method_missing(meth_id, *args)
      meth = meth_id.id2name
      case
      when meth[0..2] == 'to_'
        term = meth[3..-1]
        super unless OptionHandling.valid_terminal?(term)
        to_specific_term(term, *args)
      when meth[-1] == '!'
        option!(meth[0..-2].to_sym, *args)
      when meth[-1] == '='
        option!(meth[0..-2].to_sym, *args)
        option(meth[0..-2].to_sym)
      else
        option(meth_id, *args)
      end
    end

    ##
    # @return [true] for existing methods and
    #   #to_|term_name| when name is a valid terminal type.
    # @return [false] otherwise
    def respond_to?(meth_id, include_all=false)
      # Next line is here to force iRuby use #to_iruby
      # instead of #to_svg.
      return super if defined? IRuby
      meth = meth_id.id2name
      term = meth[0..2] == 'to_' && OptionHandling.valid_terminal?(meth[3..-1])
      term || super
    end

    ##
    # This method is used to embed plottable objects into iRuby notebooks. There is
    # {a notebook}[http://nbviewer.ipython.org/github/dilcom/gnuplotrb/blob/master/notebooks/basic_usage.ipynb]
    # with examples of its usage.
    def to_iruby
      available_terminals = {
        'png'      => 'image/png',
        'pngcairo' => 'image/png',
        'jpeg'     => 'image/jpeg',
        'svg'      => 'image/svg+xml',
        'dumb'     => 'text/plain'
      }
      terminal, options = term.is_a?(Array) ? [term[0], term[1]] : [term, {}]
      terminal = 'svg' unless available_terminals.keys.include?(terminal)
      [available_terminals[terminal], send("to_#{terminal}".to_sym, **options)]
    end

    ##
    # @private
    # Output plot to specific terminal (possibly some file).
    # Explicit use should be avoided. This method is called from #method_missing
    # when it handles method names like #to_png(options).
    #
    # @param trminal [String] terminal name ('png', 'svg' etc)
    # @param path [String] path to output file, if none given it will output to temp file
    #   and then read it and return binary contents of file
    # @param options [Hash] used in #plot
    # @example
    #   ## plot here may be Plot, Splot, Multiplot or any other plottable class
    #   plot.to_png('./result.png', size: [300, 500])
    #   contents = plot.to_svg(size: [100, 100])
    #   plot.to_dumb('./result.txt', size: [30, 15])
    def to_specific_term(terminal, path = nil, **options)
      if path
        result = plot(term: [terminal, options], output: path)
      else
        path = Dir.gnuplot_tmpname(terminal)
        plot(term: [terminal, options], output: path)
        result = File.binread(path)
        File.delete(path)
      end
      result
    end

    ##
    # @return [Terminal] terminal object linked with this Plottable object
    def own_terminal
      @terminal ||= Terminal.new
    end

    ##
    # @!method xrange(value = nil)
    # @!method yrange(value = nil)
    # @!method title(value = nil)
    # @!method option_name(value = nil)
    # Clone existing object and set new options value in created one or just return
    # existing value if nil given.
    #
    # Method is handled by #method_missing.
    #
    # You may set options using #option_name(option_value) method.
    # A new object will be constructed with selected option set.
    # And finally you can get current value of any option using
    # #options_name without arguments.
    # 
    # Available options are listed in Plot, Splot, Multiplot etc class top level doc.
    #
    # @param value new value for option
    # @return new object with option_name set to *value* if value given
    # @return old option value if no value given
    #
    # @example
    #   plot = Splot.new
    #   new_plot = plot.title('Awesome plot')
    #   plot.title #=> nil
    #   new_plot.title #=> 'Awesome plot'

    ##
    # @!method xrange!(value)
    # @!method yrange!(value)
    # @!method title!(value)
    # @!method option_name!(value)
    # Set value for an option.
    #
    # Method is handled by #method_missing.
    #
    # You may set options using obj.option_name!(option_value) or 
    # obj.option_name = option_value methods.
    # 
    # Available options are listed in Plot, Splot, Multiplot etc class top level doc.
    #
    # @param value new value for option
    # @return self
    #
    # @example
    #   plot = Splot.new
    #   plot.title #=> nil
    #   plot.title!('Awesome plot')
    #   plot.title #=> 'Awesome plot'
    #
    # @example
    #   plot = Splot.new
    #   plot.title #=> nil
    #   plot.title = 'Awesome plot'
    #   plot.title #=> 'Awesome plot'

    ##
    # @!method to_png(path = nil, **options)
    # @!method to_svg(path = nil, **options)
    # @!method to_gif(path = nil, **options)
    # @!method to_canvas(path = nil, **options)
    # Output to plot to according image format.
    #
    # All of #to_|terminal_name| methods are handled with #method_missing.
    #
    # Gnuplot offers possibility to output graphics to many image formats.
    # The easiest way to to so is to use #to_<plot_name> methods.
    #
    # @param path [String] path to save plot file to.
    # @param options [Hash] specific terminal options like 'size',
    #   'font' etc
    #
    # @return [String] contents of plotted file unless path given
    # @return self if path given
    #
    # @example
    #   # font options specific for png term
    #   multiplot.to_png('./result.png', size: [300, 500], font: ['arial', 12])
    #   # font options specific for svg term
    #   content = multiplot.to_svg(size: [100, 100], fname: 'Arial', fsize: 12)
  end
end
