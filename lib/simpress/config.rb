# frozen_string_literal: true

module Simpress
  class Config
    include Singleton

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)

    SCHEMA = {
      default: {
        logging: TrueClass,
        mode: CH::G.enum("html", "json"),
        host: String,
        paginate: [:optional, 1..10],
        source_dir: [:optional, %r{\A[^/]}],
        plugin_dir: [:optional, %r{\A[^/]}],
        output_dir: [:optional, %r{\A[^/]}],
        theme_dir: [:optional, %r{\A[^/]}],
        plugins: [:optional, [[String]]]
      }
    }.freeze

    @@attrs = attr_reader :logging, # rubocop:disable Style/ClassVars
                          :host,
                          :mode,
                          :paginate,
                          :plugin_dir,
                          :source_dir,
                          :output_dir,
                          :theme_dir,
                          :plugins

    def initialize
      config = load_config
      CH.validate(config, SCHEMA, strict: true, full: true)
      @@attrs.each {|key| instance_variable_set("@#{key}", config[:default][key]) if config[:default].include?(key) }
    end

    def self.clear
      Singleton.__init__(Simpress::Config)
    end

    private

    def load_config
      Psych.load_file(CONFIG_FILE, symbolize_names: true, freeze: true)
    end
  end
end
