# frozen_string_literal: true

module Simpress
  module Parser
    module Redcarpet
      module Filter
        def preprocess(_data)
          raise "ERROR"
        end

        class << self
          def extended(klass)
            super
            Inner.register_class(klass)
          end

          def run(body)
            data = body.dup
            Inner.instance.register_classes.each do |klass|
              res  = klass.preprocess(data)
              data = res if res.is_a?(String)
            end

            data
          end

          def clear
            Singleton.__init__(Inner)
          end
        end
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
