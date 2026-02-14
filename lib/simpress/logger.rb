# frozen_string_literal: true

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
      @logger.info(message)
    end

    def debug(message)
      @logger.debug(message)
    end

    def self.info(message)
      instance.info(message) if logging?
    end

    def self.debug(message)
      instance.debug(message)
    end

    def self.logging?
      @logging ||= Simpress::Config.instance.logging
    end

    def self.clear
      Singleton.__init__(Simpress::Logger)
    end
  end
end
