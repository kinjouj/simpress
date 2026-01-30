# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"

module Simpress
  module Plugin
    def run(*_args)
      raise NotImplementedError
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
        Dir["#{plugin_dir}/**/lib/**/*.rb"].each {|plugin| Kernel.load(plugin) }
      end

      def extended(klass)
        super
        (Thread.current[KEY] ||= []) << klass
      end

      def register_plugins
        Thread.current[KEY] || []
      end

      def process(posts = [], pages = [], categories = {})
        allowed_plugins = (Simpress::Config.instance.plugins || []).map do |plugin|
          klassname = plugin.split("_").map(&:capitalize).join
          const_get(klassname, false)
        end

        register_plugins.intersection(allowed_plugins).sort_by {|klass| -klass.priority }.each do |klass|
          Simpress::Logger.debug("REGISTER PLUGIN: #{klass}")
          klass.run(posts, pages, categories)
        end
      end

      def clear
        Thread.current[KEY] = nil
      end

      private

      def plugin_dir
        "plugins"
      end
    end
  end
end
