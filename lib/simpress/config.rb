# frozen_string_literal: true

require "classy_hash"
require "psych"
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
        paginate: [:optional, 1..10],
        output_dir: [:optional, String],
        plugins: [:optional, [[String]]]
      }
    }.freeze

    ATTRS = attr_reader(
      :logging,
      :host,
      :mode,
      :paginate,
      :output_dir,
      :plugins
    ).freeze

    def initialize
      config = Psych.load_file(CONFIG_FILE, symbolize_names: true, freeze: true, permitted_classes: [], aliases: false)
      CH.validate(config, SCHEMA, strict: true)
      config_default = config[:default]
      config_default.each {|key, value| instance_variable_set("@#{key}", value) }
    end

    def self.clear
      Singleton.__init__(Simpress::Config)
    end
  end
end
