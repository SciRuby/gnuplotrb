module GnuplotRB
  ##
  # This class corresponds to points we want to plot. It may be
  # stored in temporary file (to allow fast update) or inside
  # "$DATA << EOD ... EOD" construction. Datablock stores data passed
  # to constructor and keeps datablock name or path to file where it is stored.
  class Datablock
    ##
    # @param data [#to_gnuplot_points] anything with #to_gnuplot_points method
    # @param stored_in_file [Boolean] true here will force this datablock to store its data
    #   in temporary file.
    def initialize(data, stored_in_file = false)
      @stored_in_file = stored_in_file
      data_str = data.to_gnuplot_points
      if @stored_in_file
        @file_name = Dir.gnuplot_tmpname('tmp_data')
        File.write(@file_name, data_str)
        name = File.join(Dir.pwd, @file_name)
        ObjectSpace.define_finalizer(self, proc { File.delete(name) })
      else
        @data = data_str
      end
    end

    ##
    # Instantiate one more Datablock with updated data
    # if data stored in here-doc. Append update to file
    # if data stored there.
    #
    # @param data [#to_gnuplot_points] anything with #to_gnuplot_points method
    # @return [Datablock] self if data stored in file (see constructor)
    # @return [Datablock] new datablock with updated data otherwise
    #
    # @example
    #   data = [[0, 1, 2, 3], [0, 1, 4, 9]] # y = x**2
    #   db = Datablock.new(data, false)
    #   update = [[4, 5], [16, 25]]
    #   updated_db = db.update(update)
    #   # now db and updated_db contain DIFFERENT data
    #   # db - points with x from 0 up to 3
    #   # updated_db - points with x from 0 to 5
    #
    # @example
    #   data = [[0, 1, 2, 3], [0, 1, 4, 9]] # y = x**2
    #   db = Datablock.new(data, true)
    #   update = [[4, 5], [16, 25]]
    #   updated_db = db.update(update)
    #   # now db and updated_db contain THE SAME data
    #   # because they linked with the same temporary file
    #   # db - points with x from 0 up to 5
    #   # updated_db - points with x from 0 to 5
    def update(data)
      data_str = data.to_gnuplot_points
      if @stored_in_file
        File.open(@file_name, 'a') { |f| f.puts "\n#{data_str}" }
        self
      else
        Datablock.new("#{@data}\n#{data_str}", false)
      end
    end

    ##
    # Update existing Datablock with new data.
    # Destructive version of #update.
    #
    # @param data [#to_gnuplot_points] anything with #to_gnuplot_points method
    # @return [Datablock] self
    #
    # @example
    #   data = [[0, 1, 2, 3], [0, 1, 4, 9]] # y = x**2
    #   db = Datablock.new(data, false)
    #   update = [[4, 5], [16, 25]]
    #   db.update!(update)
    #   # now db contains points with x from 0 up to 5
    def update!(data)
      data_str = data.to_gnuplot_points
      if @stored_in_file
        File.open(@file_name, 'a') { |f| f.puts "\n#{data_str}" }
      else
        @data = "#{@data}\n#{data_str}"
      end
      self
    end

    ##
    # Get quoted filename if datablock stored in file or output
    # datablock to gnuplot and return its name otherwise.
    # 
    # @param gnuplot_term [Terminal] should be given if datablock not stored in file
    # @return [String] quoted filename if data stored in file (see contructor)
    # @return [String] Gnuplot's datablock name otherwise
    def name(gnuplot_term = nil)
      if @stored_in_file
        "'#{@file_name}'"
      else
        fail(ArgumentError, 'No terminal given to output datablock') unless gnuplot_term
        gnuplot_term.store_datablock(@data)
      end
    end

    alias_method :to_s, :name

    ##
    # Overridden #clone. Since datablock which store data
    # in temporary files should not be cloned (otherwise it will cause
    # double attempt to delete file), this #clone returns self for such
    # cases. For other cases it just calls default #clone.
    def clone
      @stored_in_file ? self : super
    end
  end
end
