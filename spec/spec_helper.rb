# frozen_string_literal: true

require "bundler/setup"
Bundler.require

require "rspec/file_fixtures"
require "simplecov"

def create_filepath(path)
  File.expand_path(path, File.dirname(caller_locations(1, 1)[0].path))
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
