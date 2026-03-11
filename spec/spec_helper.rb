# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:test)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) { FactoryBot.find_definitions }
  config.after { FactoryBot.rewind_sequences }

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

require "simplecov"

def create_filepath(path)
  File.expand_path(path, File.dirname(caller_locations(1, 1)[0].path))
end
