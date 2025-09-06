# frozen_string_literal: true

module Simpress
  module Plugin
    PLUGIN_DIR = Simpress::Config.instance.plugin_dir || "plugins"

    def run(*_args)
      raise "ERROR"
    end

    def priority
      1
    end

    def config
      Simpress::Config.instance
    end

    def bind_context(args)
      Simpress::Context.update(args)
    end

    class << self
      KEY = :simpress_plugin_classes

      def load
        Dir["#{PLUGIN_DIR}/**/lib/**/*.rb"].each {|plugin| Kernel.load(plugin) }
      end

      def extended(klass)
        super
        Thread.current[KEY] ||= Set.new
        Thread.current[KEY] << klass
      end

      def register_plugins
        Thread.current[KEY] || []
      end

      def process(posts = [], pages = [], categories = {})
        allowed_plugins = (Simpress::Config.instance.plugins || []).map do |plugin|
          klassname = plugin.to_s.split("_").map(&:capitalize).join
          Simpress::Plugin.const_get(klassname)
        end

        (register_plugins & allowed_plugins).sort_by {|klass| -klass.priority }.each do |klass|
          Simpress::Logger.debug("REGISTER PLUGIN: #{klass}")
          klass.run(posts, pages, categories)
        end
      end

      def clear
        Thread.current[KEY] = nil
      end
    end
  end
end
