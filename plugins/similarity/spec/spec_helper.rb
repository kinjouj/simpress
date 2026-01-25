# frozen_string_literal: true

require "bundler/setup"
Bundler.require

Dir[File.join(__dir__, "support/**/*.rb")].each {|f| require f }

require "simplecov"

RSpec.configure do |config|
  config.include FixtureHelper
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
