# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"

module Simpress
  module Plugin
    def run(posts = [], pages = [])
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
      def load
        Dir["#{Simpress::Config.plugin_dir}/**/lib/simpress/plugin/*.rb"].each {|plugin| Kernel.load(plugin) }
      end

      def extended(klass)
        super
        register_plugins << klass
      end

      def register_plugins
        @register_plugins ||= Set.new
      end

      def process(posts = [], pages = [])
        plugins = Simpress::Config.instance.plugins.to_set {|plugin| plugin.downcase.delete("_") }
        allowed_plugins = register_plugins.select {|klass| plugins.include?(klass.name.split("::").last.downcase) }
                                          .sort_by {|klass| -klass.priority }

        allowed_plugins.each do |klass|
          Simpress::Logger.debug("REGISTER PLUGIN: #{klass}")
          klass.run(posts, pages)
        end
      end

      def clear
        @register_plugins&.clear
      end
    end
  end
end
