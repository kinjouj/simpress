# frozen_string_literal: true

require "zeitwerk"

require "simpress/config"
require "simpress/context"
require "simpress/logger"
require "simpress/parser/markdown/filter"

module Simpress
  module Plugin
    def run(posts = [])
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
        @loader = Zeitwerk::Loader.new
        @loader.on_load do |_cpath, value, _abspath|
          case value
          when Simpress::Plugin
            Simpress::Logger.debug("REGISTER PLUGIN: #{value}")
            register_plugins << value
          when Simpress::Parser::Markdown::Filter
            Simpress::Logger.debug("REGISTER FILTER: #{value}")
            Simpress::Parser::Markdown::Filter.register_filters << value
          end
        end

        Simpress::Config.instance.plugins.each {|name| @loader.push_dir("#{Simpress::Config.plugin_dir}/#{name}/lib") }
        @loader.setup
        @loader.eager_load
      end

      def process(posts = [])
        register_plugins.sort_by {|klass| -klass.priority }.each {|klass| klass.run(posts) }
      end

      def clear
        Simpress::Parser::Markdown::Filter.clear
        @loader&.unload
        @register_plugins&.clear
        @loader = nil
      end
    end
  end
end
