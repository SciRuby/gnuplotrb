# GnuplotRB
GnuplotRB is a plot generator for Ruby based on
[Gnuplot](http://www.gnuplot.info).

This software has been developed as a product in Google Summer of Code 2015 (GSoC2015). Its progress may be saw in [SciRuby mailing list](https://groups.google.com/forum/?fromgroups#!topic/sciruby-dev/lhWvb5hWc3k) or in [project's blog](http://www.evgrafov.work/gnuplotrb/).

[![Gem Version](https://badge.fury.io/rb/gnuplotrb.svg)](https://badge.fury.io/rb/gnuplotrb)
[![Dependency Status](https://gemnasium.com/badges/github.com/SciRuby/gnuplotrb.svg)](https://gemnasium.com/github.com/SciRuby/gnuplotrb)
[![Build Status](https://travis-ci.org/SciRuby/gnuplotrb.svg?branch=master)](https://travis-ci.org/SciRuby/gnuplotrb)
[![Code Climate](https://codeclimate.com/github/SciRuby/gnuplotrb/badges/gpa.svg)](https://codeclimate.com/github/SciRuby/gnuplotrb)
[![Test Coverage](https://codeclimate.com/github/SciRuby/gnuplotrb/badges/coverage.svg)](https://codeclimate.com/github/SciRuby/gnuplotrb/coverage)

## Table of contents
* [Installation](https://github.com/sciruby/gnuplotrb#installation)
* [Getting started](https://github.com/sciruby/gnuplotrb#getting-started)
  - [Plottable classes](https://github.com/sciruby/gnuplotrb#plottable-classes)
  - [Notebooks](https://github.com/sciruby/gnuplotrb#notebooks)
  - [Plain examples](https://github.com/sciruby/gnuplotrb#plain-examples)
* [Contributing](https://github.com/sciruby/gnuplotrb#contributing)

## Installation
### Dependencies
*   Ruby 2.0+
*   It is required to install [gnuplot 5.0](http://www.gnuplot.info/download.html) to use that gem.

### Gem installation
#### Install latest stable version from Rubygems

```sh
gem install gnuplotrb
```

#### Install latest stable version using bundler
* add `gem gnuplotrb` to your `Gemfile`
* run `bundle install`

#### Install latest version from source (may be unstable)

```sh
git clone https://github.com/sciruby/gnuplotrb.git
cd gnuplotrb
bundle install
rake install
```

## Getting started
GnuplotRB gem is based on [Gnuplot](http://www.gnuplot.info/) so I would recommend to use [Gnuplot doc](http://www.gnuplot.info/docs_5.0/gnuplot.pdf) and [GnuplotRB doc at Rubydoc](https://rubygems.org/gems/gnuplotrb) in cases when docs and examples (as notebooks and plain examples) present here are not enough to explain how to plot something.

### Plottable classes
Each of plottable classes may be outputted to image file using ```#to_png```, ```#to_svg```, ```#to_gif``` and so on methods. You can read more about it in [GnuplotRB doc](https://rubygems.org/gems/gnuplotrb) related to Plottable module or see examples in [beginners
notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/basic_usage.ipynb).

#### Dataset
Single dataset may be created with math formula ('sin(x)') or some data. If your data is stored in a file you can just pass a filename (e.g. 'gnuplotrb.data'). Dataset may also be constructed out of data contained in Ruby classes (Array, Daru containers), see [example notebooks](https://github.com/sciruby/gnuplotrb#possible-datasources).

Dataset have several possible options which are explained in [gnuplot
doc](http://www.gnuplot.info/docs_5.0/gnuplot.pdf) (pp. 80-102). Options are passed to Dataset.new as hash and are tranlated into gnuplot format before plotting:

```ruby
Dataset.new(data, with: 'lines', using: '1:2')
```

Examples of option translation (nested containers allowed):

* Hash:

```ruby
{ key1: "value1", key2: { nested_key1: "nested_value1" } } # => "key1 value1 key2 nested key1 nested_value1"
```

* Hashes with underscored keys (see [#7](https://github.com/dilcom/gnuplotrb/issues/7)):

```ruby
{ style_data: 'histograms' } #=> "style data histograms"
```

* Range:

```ruby
{ xrange: 0..100 } # => "xrange [0:100]"
```

* Array (often used with nested hashes) and Array of Numeric

```ruby
['png', { size: [400, 500] }] # => "png size 400,500"
```

* Others

```ruby
some_object # => some_object.to_s
```

Once Dataset created, it may be updated with new data or options. Methods related to updating are explained in [a notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/updating_data.ipynb).

Just as other Plottable object Dataset has several plotting methods which are desribed in [beginners notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/basic_usage.ipynb).

#### Plot
Plot is a container for several datasets and layout options:
```ruby
Plot.new(ds1, ds2, ds2, xrange: 1..10)
```

Datasets contained bu Plot are outputted on single xy plain.

Plot's options are explained in [gnuplot doc](http://www.gnuplot.info/docs_5.0/gnuplot.pdf) (pp. 105-181). Plot options are translated into gnuplot format the same way as Dataset's (except adding 'set' before each option). Plot's datasets and Plot itself may be updated with almost the same methods as desribed in Dataset section above.

#### Splot
Almost the same as Plot but for 3-D plots. See Plot section.

#### Multiplot

Container for several Plot or Splot objects, each of them is plotted in its own xy(z) space. So Multiplot offers single layout (image filewindow) for several plots. It's grid is tuned by :layout option, and you can also set layout's title:
```ruby
Multiplot.new(plot1, plot2, splot1, layout: [3, 1], title: 'Three plots on a layout')
```

Updating methods for Multiplot are almost the same as Plot's and Dataset's and are covered in Multiplot's docs and [multiplot notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/multiplot_layout.ipynb). See examples there.

#### Animation

Animation is a container for several Plot, Splot or Multiplot objects. Each of contained items is considered as frame in gif animation which is creating by ```#plot``` call. Animation's frames and options may be modifyed or updated just as other classes above. Animation does not support methods like ```#to_png``` and may be plotted only with ```#plot``` method. Please see [related notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/animated_plots.ipynb) and docs at RubyDoc for examples.

### Notebooks

This notebooks are powered by [Ruby kernel](https://github.com/SciRuby/iruby/) for [IPython/Jupyter](https://jupyter.org/). I placed them here to show some GnuplotRB's capabilities and ways of using it together with iRuby.

To use GnuplotRB gem with iRuby you need to install them both.

* iRuby installation is covered in its [README](https://github.com/SciRuby/iruby/blob/master/README.md). It also covers installation of iPython and other dependecies.
* GnuplotRB gem installation covered in [README](https://github.com/sciruby/gnuplotrb#installation) too.


#### Embedding plots into iRuby
Using GnuplotRB inside iRuby notebooks is covered in:

* [Basic usage notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/basic_usage.ipynb).

#### 2D and 3D plots
GnuplotRB is capable to plot vast range of plots from histograms to 3D
heatmaps. Gem's repository contains examples of several plot types:

* [Heatmaps](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/heatmaps.ipynb)
* [Vectorfield](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/vector_field.ipynb) (Thanks, [Alexej](https://github.com/agisga))
* [Math equations](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/math_plots.ipynb)
* [3D visualizations](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/3d_plot.ipynb)
* [Histogram](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/histogram.ipynb)


#### Possible datasources
GnuplotRB may take data in Ruby container or in a file. Supported containers
for now are `Array`, `Daru::Vector` and `Daru::DataFrame`. When data given in file,
GnuplotRB pass filename to Gnuplot **without** reading the file into memory.

Examples of using different datasources:

* [Data given in file or Ruby Array](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/points_from_different_sources.ipynb)
* [Data given in Daru containers](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/plotting_from_daru.ipynb)
* [Data given in Daru containers (with timeseries)](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/time_series_from_daru.ipynb)
* [Updating plots with new data](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/updating_data.ipynb)


#### Multiplot
You can not only plot several datasets in single coordinate system but place
several coordinate systems on a canvas.

* [Multiplot example notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/multiplot_layout.ipynb).

#### Animation
It's possible to use several plots (Plot, Splot or Multiplot objects) to create gif animation.

* [Animation example notebook](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/animated_plots.ipynb).


#### Fitting data with formula
GnuplotRB also may be used to fit some data with given math formula.

* [Fitting data](http://nbviewer.ipython.org/github/sciruby/gnuplotrb/blob/master/notebooks/fitting_data.ipynb)


### Plain examples
You may find several examples in [examples directory](https://github.com/sciruby/gnuplotrb/tree/master/examples).

## Contributing

1.  [Fork repository](https://github.com/sciruby/gnuplotrb/fork)
2.  Create your feature branch (`git checkout -b my-new-feature`)
3.  Commit your changes (`git commit -am 'Add some feature'`)
4.  Push to the branch (`git push origin my-new-feature`)
5.  Create a new Pull Request

