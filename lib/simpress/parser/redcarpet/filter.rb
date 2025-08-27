# frozen_string_literal: true

module Simpress
  module Parser
    module Redcarpet
      module Filter
        def preprocess(_data)
          raise "ERROR"
        end

        class << self
          @@register_classes = []

          def extended(klass)
            super
            @@register_classes << klass
          end

          def run(body)
            data = body.dup
            @@register_classes.each do |klass|
              res  = klass.preprocess(data)
              data = res if res.is_a?(String)
            end

            data
          end

          def clear
            @@register_classes = []
          end
        end
      end
    end
  end
end
