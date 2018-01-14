require 'tempfile'
require 'hamster'
require 'open3'
require 'base64'

##
# Require gem if it's available in current gemspace.
#
# @param name [String] gem name
# @return [Boolean] true if gem was loaded, false otherwise
def require_if_available(name)
  require name
rescue LoadError
  false
end

require_if_available('daru')

require 'gnuplotrb/external_classes/string'
require 'gnuplotrb/external_classes/array'
require 'gnuplotrb/external_classes/daru'
require 'gnuplotrb/external_classes/dir'


require 'gnuplotrb/version'
require 'gnuplotrb/staff/settings'
require 'gnuplotrb/mixins/option_handling'
require 'gnuplotrb/mixins/error_handling'
require 'gnuplotrb/mixins/plottable'
require 'gnuplotrb/staff/terminal'
require 'gnuplotrb/staff/datablock'
require 'gnuplotrb/staff/dataset'
require 'gnuplotrb/fit'
require 'gnuplotrb/plot'
require 'gnuplotrb/splot'
require 'gnuplotrb/multiplot'
require 'gnuplotrb/animation'
