# frozen_string_literal: true

require "bundler/setup"
Bundler.require(:default, :test)

Oj.mimic_JSON
Dir[File.expand_path("../plugins/*/lib", __dir__)].each {|lib| $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib) }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) { FactoryBot.find_definitions }
  config.after { FactoryBot.rewind_sequences }
  config.expect_with(:rspec) {|expectations| expectations.include_chain_clauses_in_custom_matcher_descriptions = true }
  config.mock_with(:rspec) {|mocks| mocks.verify_partial_doubles = true }
end

require "simplecov"
