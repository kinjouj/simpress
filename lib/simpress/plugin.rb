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

      def plugin_dir
        Simpress::Config.instance.plugin_dir || "plugins"
      end

      def load
        Dir["#{plugin_dir}/**/lib/**/*.rb"].each {|plugin| Kernel.load(plugin) }
      end

      def extended(klass)
        super
        (Thread.current[KEY] ||= Set.new) << klass
      end

      def register_plugins
        Thread.current[KEY] || []
      end

      def process(posts = [], pages = [], categories = {})
        allowed_plugins = (Simpress::Config.instance.plugins || []).map do |plugin|
          klassname = plugin.to_s.split("_").map(&:capitalize).join
          const_get(klassname, false)
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

    private_class_method :plugin_dir
  end
end
