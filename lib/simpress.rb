# frozen_string_literal: true

require "stackprof"

require "benchmark"
require "simpress/generator"
require "simpress/logger"
require "simpress/plugin"

module Simpress
  def self.build
    StackProf.run(mode: :wall, out: "stackprof.dump") do
      Simpress::Plugin.load
      Simpress::Generator.generate
    end

    # :nocov:
    yield if block_given?
    # :nocov:
  end
end
