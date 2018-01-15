##
# Utility methods for GnuplotRB.
class Dir
  # @return temporary file name
  def self.gnuplot_tmpname(name)
    t = Time.now.strftime('%Y%m%d')
    "#{Dir.tmpdir}/gnuplotrb-#{name}-#{t}-#{$PID}-#{rand(0x100000000).to_s(36)}"
  end
end
