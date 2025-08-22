# frozen_string_literal: true

module Simpress
    module Preprocessor
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
          Inner.register_class(klass)
        end

        def process(posts, pages, categories)
          plugins = (Simpress::Config.instance.preprocessors || []).map do |preprocessor|
            klassname = preprocessor.to_s.split("_").map(&:capitalize).join
            Simpress::Preprocessor.const_get(klassname)
          end

          (Inner.instance.register_classes & plugins).sort_by {|klass| -klass.priority }.each do |klass|
            Simpress::Logger.debug(klass.to_s)
            klass.run(posts, pages, categories)
          end
        end

        def finish
          Singleton.__init__(Inner)
        end
      end

      class Inner
        include Singleton

        attr_reader :register_classes

        def initialize
          @register_classes = []
        end

        def self.register_class(klass)
          instance.register_classes << klass
        end
      end

      private_constant :Inner
    end
end
