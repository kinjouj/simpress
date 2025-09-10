# frozen_string_literal: true

module Simpress
  class Logger
    include Singleton

    LOG_FILE = File.expand_path("../../logs/build.log", __dir__)

    def initialize
      tee = Tee.open(LOG_FILE)
      @logger = ::Logger.new(tee)
      $stdout = tee
    end

    def info(message)
      @logger.info(message)
    end

    def debug(message)
      @logger.debug(message)
    end

    def self.info(message)
      Simpress::Logger.instance.info(message) if Simpress::Config.instance.logging
    end

    def self.debug(message)
      Simpress::Logger.instance.debug(message)
    end

    def self.clear
      Singleton.__init__(Simpress::Logger)
    end
  end
end
