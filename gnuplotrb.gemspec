# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gnuplotrb/version'

Gem::Specification.new do |spec|
  spec.name          = 'gnuplotrb'
  spec.version       = GnuplotRB::VERSION
  spec.authors       = ['Ivan Evgrafov']
  spec.email         = ['dilcom3107@gmail.com']

  spec.summary       = 'Ruby bindings for gnuplot'
  spec.description   = 'Renewed ruby bindings for gnuplot. Started at GSoC 2015.'
  spec.homepage      = 'https://github.com/dilcom/gnuplotrb'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(/^(test|spec|unimplemented_features|examples|future_work|notebooks|\..+)/) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'hamster', '~> 3.0'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'rubocop', '~> 0.29'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'chunky_png'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'daru'
end
