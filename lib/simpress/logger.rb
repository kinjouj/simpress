# frozen_string_literal: true

require "forwardable"
require "logger"
require "singleton"
require "simpress/config"

module Simpress
  class Logger
    include Singleton

    def initialize
      @logger = ::Logger.new($stdout)
    end

    def verbose(message = nil, &)
      @logger.info(message, &) if Simpress::Config.logging
    end

    def debug(message)
      @logger.debug(message)
    end

    class << self
      extend Forwardable

      def_delegators :instance, :verbose, :debug

      # simplecov:disable
      def clear
        Singleton.__init__(Simpress::Logger)
      end
      # simplecov:enable
    end
  end
end
