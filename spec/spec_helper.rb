# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:test)

Dir[File.join(__dir__, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include PostDataHelper

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
