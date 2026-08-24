# frozen_string_literal: true

require "psych"
require "singleton"

module Simpress
  class Config
    include Singleton

    CONFIG_FILE     = File.expand_path("../../config.yaml", __dir__)
    TAXONOMIES_FILE = File.expand_path("../../taxonomies.yaml", __dir__)

    attr_reader :logging, :host, :mode, :paginate, :plugins

    def initialize
      config      = Psych.load_file(CONFIG_FILE, symbolize_names: true, freeze: true, permitted_classes: [], aliases: false)
      defaults    = config.fetch(:default) { raise "config.yaml is missing 'default' key" }
      @mode       = defaults[:mode]
      @host       = defaults[:host]
      @logging    = defaults[:logging]
      @paginate   = defaults[:paginate]
      @plugins    = defaults[:plugins]
    end

    def taxonomies
      @taxonomies ||= File.exist?(TAXONOMIES_FILE) ? Psych.load_file(TAXONOMIES_FILE) || {} : {}
    end

    # simplecov:disable
    class << self
      def source_dir
        "source"
      end

      def theme_dir
        "theme"
      end

      def output_dir
        "public"
      end

      def plugin_dir
        "plugins"
      end

      def clear
        Singleton.__init__(Simpress::Config)
      end
    end
    # simplecov:enable
  end
end
