# frozen_string_literal: true

require "psych"
require "singleton"

module Simpress
  class Config
    include Singleton

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)
    attr_reader :logging, :host, :mode, :paginate, :plugins

    def initialize
      config = Psych.load_file(CONFIG_FILE, symbolize_names: true, freeze: true, permitted_classes: [], aliases: false)
      config_default = config[:default]
      config_default.each {|k, v| instance_variable_set("@#{k}", v) }
    end

    class << self
      # :nocov:
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
      # :nocov:

      def clear
        Singleton.__init__(Simpress::Config)
      end
    end
  end
end
