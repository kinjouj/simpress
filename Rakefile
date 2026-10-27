# frozen_string_literal: true

$LOAD_PATH.unshift "./lib"

require "bundler/setup"
Bundler.require(:test)

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = "spec/**/*_spec.rb,plugins/*/spec/**/*_spec.rb"
end
