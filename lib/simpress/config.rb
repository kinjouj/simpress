# frozen_string_literal: true

require "forwardable"
require "psych"
require "singleton"

module Simpress
  class Config
    include Singleton

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)
    TAXONOMIES_FILE = File.expand_path("../../taxonomies.yaml", __dir__)
    LOAD_OPTIONS = { permitted_classes: [], symbolize_names: true, freeze: true }.freeze

    attr_reader :logging, :host, :mode, :paginate, :plugins

    def initialize
      config = Psych.load_file(CONFIG_FILE, **LOAD_OPTIONS)
      defaults = config.fetch(:default) { raise "config.yaml is missing 'default' key" }
      @mode = defaults[:mode]
      @host = defaults[:host]
      @logging = defaults[:logging]
      @paginate = defaults[:paginate]
      @plugins = defaults[:plugins]
    end

    def taxonomies
      @taxonomies ||= File.exist?(TAXONOMIES_FILE) ? Psych.load_file(TAXONOMIES_FILE, **LOAD_OPTIONS) || {} : {}
    end

    class << self
      extend Forwardable

      def_delegators :instance, :logging, :host, :mode, :paginate, :plugins, :taxonomies

      def source_dir = "source"
      def theme_dir = "theme"
      def output_dir = "public"
      def plugin_dir = "plugins"

      # simplecov:disable
      def clear
        Singleton.__init__(Simpress::Config)
      end
      # simplecov:enable
    end
  end
end
