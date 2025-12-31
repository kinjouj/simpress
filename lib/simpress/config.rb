# frozen_string_literal: true

require "classy_hash"
require "singleton"

module Simpress
  class Config
    include Singleton

    CONFIG_FILE = File.expand_path("../../config.yaml", __dir__)

    SCHEMA = {
      default: {
        logging: CH::G.enum(true, false),
        mode: CH::G.enum("html", "json"),
        host: String,
        paginate: [ :optional, 1..10 ],
        source_dir: [ :optional, %r{\A[^/]} ],
        plugin_dir: [ :optional, %r{\A[^/]} ],
        output_dir: [ :optional, %r{\A[^/]} ],
        theme_dir: [ :optional, %r{\A[^/]} ],
        plugins: [ :optional, [[ String ] ]]
      }
    }.freeze

    ATTRS = attr_reader(:logging, :host, :mode, :paginate, :plugin_dir, :source_dir, :output_dir, :theme_dir, :plugins).freeze

    def initialize
      config = load_config
      CH.validate(config, SCHEMA, strict: true, full: true)
      ATTRS.each {|key|
        instance_variable_set("@#{key}", config[:default][key])
      }
    end

    def self.clear
      Singleton.__init__(Simpress::Config)
    end

    private

    def load_config
      Psych.safe_load_file(CONFIG_FILE, symbolize_names: true, freeze: true, permitted_classes: [], aliases: false)
    end
  end
end
