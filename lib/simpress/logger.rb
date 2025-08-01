# frozen_string_literal: true

module Simpress
  class Logger
    include Singleton
    LOGFILE = File.expand_path("../../logs/build.log", __dir__)

    def initialize
      tee = Tee.open(LOGFILE)
      $stdout = tee
      @logger = ::Logger.new(tee)
    end

    def info(message)
      @logger.info(message)
    end

    def warn(message)
      @logger.warn(message)
    end

    def debug(message)
      @logger.debug(message)
    end

    def self.info(message)
      Simpress::Logger.instance.info(message) if Simpress::Config.instance.logging
    end

    def self.warn(message)
      Simpress::Logger.instance.warn(message)
    end

    def self.debug(message)
      caller = caller_locations(1, 1)[0]
      Simpress::Logger.instance.debug("#{caller.path}: #{message}") if Simpress::Config.instance.debug
    end
  end
end
