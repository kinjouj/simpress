# frozen_string_literal: true

require "stackprof"
require "simpress/generator"
require "simpress/plugin"

module Simpress
  def self.build
    Simpress::Plugin.load
    StackProf.run(mode: :wall, out: "stackprof.dump") do
      Simpress::Generator.generate
    end
    # :nocov:
    yield if block_given?
    # :nocov:
  end
end
