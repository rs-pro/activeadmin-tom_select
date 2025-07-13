# encoding: utf-8

require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  # RSpec not available
end

begin
  require 'semmy'
  Semmy::Tasks.install
rescue LoadError
  # Semmy not available
end
