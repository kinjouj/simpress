# frozen_string_literal: true

require "simpress/generator"
require "simpress/plugin"

module Simpress
  def self.build
    Simpress::Plugin.load
    Simpress::Generator.generate
    # :nocov:
    yield if block_given?
    # :nocov:
  end
end
