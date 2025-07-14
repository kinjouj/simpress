# frozen_string_literal: true

module Simpress
  module Plugin
    module Preprocessor
      attr_accessor :params

      def run(*_args)
        raise "ERROR"
      end

      def config
        Simpress::Config.instance
      end

      def register_context(**args)
        Simpress::Context.update(args)
      end

      def self.extended(klass)
        super
        Inner.register_class(klass)
      end

      def self.process(*args)
        plugins = Set.new(Simpress::Config.instance.preprocessors || []).map do |preprocessor|
          next unless preprocessor.is_a?(String)

          klassname = preprocessor.split("_").map(&:capitalize).join
          Simpress::Plugin::Preprocessor.const_get(klassname)
        end

        Inner.instance.register_classes.each do |klass|
          next unless plugins.include?(klass)

          Simpress::Logger.debug(klass.to_s)
          klass.run(*args)
        end
      end

      def self.finish
        Singleton.__init__(Inner)
      end

      class Inner
        include Singleton
        attr_reader :register_classes

        def initialize
          @register_classes = Set.new
        end

        def self.register_class(klass)
          instance.register_classes << klass
        end
      end

      private_constant :Inner
    end
  end
end
