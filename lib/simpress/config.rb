# frozen_string_literal: true

module Simpress
  class Config
    include ::Singleton
    include Jsonable

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)

    SCHEMA = {
      default: {
        debug: TrueClass,
        logging: TrueClass,
        mode: CH::G.enum("html", "json"),
        host: String,
        paginate: [ :optional, Integer ],
        source_dir: [ :optional, String ],
        plugin_dir: [ :optional, String ],
        output_dir: [ :optional, String ],
        theme_dir: [ :optional, String ],
        cache_dir: [ :optional, String ],
        preprocessors: [ :optional, [[String]] ]
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
      bind_values(config[:default])
    end

    def self.clear
      Singleton.__init__(Simpress::Config)
    end

    private

    def bind_values(config)
      @@attrs.each do |key|
        instance_variable_set("@#{key}", config[key]) if config.include?(key)
      end
    end
  end
end
