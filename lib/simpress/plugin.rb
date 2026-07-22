# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "zeitwerk"

module Simpress
  module Plugin
    class UnknownModeError < StandardError; end

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
      def register_plugins
        @register_plugins ||= Set.new
      end

      def load
        enabled_plugins = Simpress::Config.instance.plugins.to_set
        @loader = Zeitwerk::Loader.new
        @loader.on_load do |cpath, value, _abspath|
          next unless value.is_a?(Simpress::Plugin)

          name = underscore(cpath.split("::").last)
          register_plugins << value if enabled_plugins.include?(name)
        end

        Dir["#{Simpress::Config.plugin_dir}/*/lib"].each {|lib_dir| @loader.push_dir(lib_dir) }
        @loader.setup
        @loader.eager_load
      end

      def process(posts = [], pages = [])
        register_plugins.sort_by {|klass| -klass.priority }.each do |klass|
          Simpress::Logger.debug("REGISTER PLUGIN: #{klass}")
          klass.run(posts, pages)
        end
      end

      def clear
        @register_plugins&.clear
        @loader&.unload
        @loader = nil
      end

      private

      def underscore(name)
        name.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
      end
    end
  end
end
