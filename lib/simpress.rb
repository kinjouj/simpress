# frozen_string_literal: true

# require "stackprof"
require "simpress/generator"
require "simpress/plugin"

module Simpress
  def self.build
    Simpress::Plugin.load
    Simpress::Generator.generate

    # StackProf.run(mode: :wall, out: "stackprof.dump") do
    #   Simpress::Generator.generate
    # end

    yield if block_given? # simplecov:disable
  end
end
