begin
  require "./spec/spec_helper"
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end
