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
      def load
        Dir["#{PLUGIN_DIR}/**/lib/**/*.rb"].each {|plugin| Kernel.load(plugin) }
      end

      def extended(klass)
        super
        Thread.current[:plugin_classes] ||= []
        Thread.current[:plugin_classes] << klass
      end

      def all
        Thread.current[:plugin_classes] || []
      end

      def process(posts = [], pages = [], categories = {})
        plugins = (Simpress::Config.instance.plugins || []).map do |plugin|
          klassname = plugin.to_s.split("_").map(&:capitalize).join
          Simpress::Plugin.const_get(klassname)
        end

        (all & plugins).sort_by {|klass| -klass.priority }.each do |klass|
          Simpress::Logger.debug(klass.to_s)
          klass.run(posts, pages, categories)
        end
      end

      def clear
        Thread.current[:plugin_classes] = nil
      end
    end
  end
end
