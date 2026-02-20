# frozen_string_literal: true

require "psych"
require "singleton"

module Simpress
  class Config
    include Singleton

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)

    attr_reader :logging,
                :host,
                :mode,
                :paginate,
                :plugins

    def initialize
      config = Psych.load_file(CONFIG_FILE, symbolize_names: true, freeze: true, permitted_classes: [], aliases: false)
      config_default = config[:default]
      @mode     = config_default[:mode]
      @logging  = config_default[:logging]
      @host     = config_default[:host]
      @paginate = config_default[:paginate]
      @plugins  = config_default[:plugins]
    end

    def self.clear
      Singleton.__init__(Simpress::Config)
    end

    # :nocov:
    def self.output_dir
      "public"
    end
    # :nocov:
  end
end
