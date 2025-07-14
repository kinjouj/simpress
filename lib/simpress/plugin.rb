# frozen_string_literal: true

module Simpress
  module Plugin
    PLUGIN_DIR = Simpress::Config.instance.plugin_dir || "plugins"

    def self.load
      Dir["#{PLUGIN_DIR}/**/lib/**/*.rb"].each {|plugin| Kernel.load(plugin) }
    end
  end
end
