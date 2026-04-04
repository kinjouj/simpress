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

    def info(message)
      @logger.info(message) if logging?
    end

    def debug(message)
      @logger.debug(message)
    end

    def logging?
      Simpress::Config.instance.logging
    end

    class << self
      extend Forwardable

      def_delegators :instance, :info, :debug

      def clear
        Singleton.__init__(Simpress::Logger)
      end
    end
  end
end
