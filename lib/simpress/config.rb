# frozen_string_literal: true

module Simpress
  class Config
    include Singleton
    include Jsonable

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)

    SCHEMA = {
      default: {
        debug: TrueClass,
        logging: TrueClass,
        mode: CH::G.enum("html", "json"),
        host: String,
        paginate: [:optional, 1..10],
        source_dir: [:optional, %r{\A[^\/]}],
        plugin_dir: [:optional, %r{\A[^\/]}],
        output_dir: [:optional, %r{\A[^\/]}],
        theme_dir: [:optional, %r{\A[^\/]}],
        cache_dir: [:optional, %r{\A[^\/]}],
        preprocessors: [:optional, [[String]]]
      }
    }.freeze

    @@attrs = attr_reader :debug,
                          :logging,
                          :mode,
                          :host,
                          :paginate,
                          :source_dir,
                          :plugin_dir,
                          :output_dir,
                          :theme_dir,
                          :cache_dir,
                          :preprocessors

    def initialize
      config = Psych.load_file(CONFIG_FILE, symbolize_names: true)
      CH.validate(config, SCHEMA, strict: true)
      @@attrs.each {|key| instance_variable_set("@#{key}", config[:default][key]) if config[:default].include?(key) }
    end

    def self.clear
      Singleton.__init__(Simpress::Config)
    end
  end
end
