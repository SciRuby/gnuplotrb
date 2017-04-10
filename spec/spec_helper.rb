require 'simplecov'
require 'codeclimate-test-reporter'
require 'digest'
require 'chunky_png'
require 'digest/md5'

SimpleCov.start do
  add_filter 'examples'
end

require 'gnuplotrb'

include ChunkyPNG::Color
include GnuplotRB
include GnuplotRB::Fit

$RSPEC_TEST = true

def same_images?(*imgs)
  images = imgs.map { |img| Digest::MD5.digest(ChunkyPNG::Image.from_file(img).pixels.to_s) }
  images.all? { |img| img == images[0] }
end

# may be errorneuos in comparing images
def same_files?(*files)
  images = files.map { |fname| Digest::MD5.digest(File.binread(fname)) }
  images.all? { |img| img == images[0] }
end

def awesome?
  # sure!
  true
end

def run_example_at(path)
  Dir.chdir(path) do
    FileUtils.rm(Dir["#{Dir.pwd}/*.png"])
    require "#{Dir.pwd}/plot.rb"
    # run gnuplot without output to current console
    `gnuplot plot.gnuplot 2>&1`
    same_images?('gnuplot.png', 'gnuplot_gem.png')
  end
end
