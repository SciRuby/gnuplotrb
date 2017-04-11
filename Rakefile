require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rspec/core'
require 'yard'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb'].uniq
  spec.rspec_opts = '--format documentation --color'
end

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = %w(README.md lib)   # optional
end

RuboCop::RakeTask.new(:cop)
