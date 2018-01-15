module GnuplotRB
  ##
  # Animation allows to create gif animation with given plots
  # as frames. Possible frames: Plot, Splot, Multiplot.
  # More about its usage in
  # {animation notebook}[http://nbviewer.ipython.org/github/dilcom/gnuplotrb/blob/master/notebooks/animated_plots.ipynb].
  #
  # == Options
  # Animations has several specific options:
  # * animate - allows to get animated gif's. Possible values are true (just turn on animation),
  #   ot hash with suboptions (:loop - count of loops, default 0 - infinity$; 
  #   :delay - delay between frames; :optimize - boolean, reduces file size).
  # * size - size of gif file in pixels (size: [500, 500]) or (size: 500)
  # * background - background color
  # * transparent
  # * enhanced
  # * font
  # * fontscale
  # * crop
  #
  # Animation ignores :term option and does not have methods like #to_png or #to_svg.
  # One can also set animation any options related to Plot and they will be considered
  # by all nested plots (if they does not override it with their own values).
  #
  # Animation inherits all plot array handling methods from Multiplot
  # and adds aliases for them (#plots -> #frames; #update_frame! -> #update_plot!; etc).
  class Animation < Multiplot
    ##
    # *Plot* here is also named as *frame*
    alias_method :frames, :plots
    alias_method :update_frame, :update_plot
    alias_method :replace_frame, :replace_plot
    alias_method :add_frame, :add_plot
    alias_method :add_frames, :add_plots
    alias_method :remove_frame, :remove_plot
    alias_method :update_frame!, :update_plot!
    alias_method :replace_frame!, :replace_plot!
    alias_method :add_frame!, :add_plot!
    alias_method :add_frames!, :add_plots!
    alias_method :remove_frame!, :remove_plot!

    ##
    # This method creates a gif animation where frames are plots
    # already contained by Animation object.
    #
    # Options passed in #plot have priority over those which were set before.
    #
    # Inner options of Plots have the highest priority (except
    # :term and :output which are ignored).
    #
    # @param path [String] path to new gif file that will be created as a result
    # @param options [Hash] see note about available options in top class documentation
    # @return [nil] if path to output file given
    # @return [String] gif file contents if no path to output file given
    def plot(path = nil, **options)
      options[:output] ||= path
      plot_options = mix_options(options) do |plot_opts, anim_opts|
        plot_opts.merge(term: ['gif', anim_opts])
      end.to_h
      need_output = plot_options[:output].nil?
      plot_options[:output] = Dir.gnuplot_tmpname('anim') if need_output
      terminal = Terminal.new
      multiplot(terminal, plot_options)
      # guaranteed wait for plotting to finish
      terminal.close
      if need_output
        result = File.binread(plot_options[:output])
        File.delete(plot_options[:output])
      else
        result = nil
      end
      result
    end

    ##
    # #to_|term_name| methods are not supported by animation
    def to_specific_term(*_)
      fail 'Specific terminals are not supported by Animation'
    end

    ##
    # This method is used to embed gif animations
    # into iRuby notebooks.
    def to_iruby
      gif_base64 = Base64.encode64(plot)
      ['text/html', "<img src=\"data:image/gif;base64, #{gif_base64}\">"]
    end

    private

    ##
    # Dafault options to be used for that plot
    def default_options
      {
        animate: {
          delay: 10,
          loop: 0,
          optimize: true
        }
      }
    end

    ##
    # This plot have some specific options which
    # should be handled different way than others.
    # Here are keys of this options.
    def specific_keys
      %w(
        animate
        size
        background
        transparent
        enhanced
        rounded
        butt
        linewidth
        dashlength
        tiny
        small
        medium
        large
        giant
        font
        fontscale
        crop
      )
    end
  end
end
