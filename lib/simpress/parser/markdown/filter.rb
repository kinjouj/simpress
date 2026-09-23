# frozen_string_literal: true

module Simpress
  module Parser
    module Markdown
      module Filter
        def preprocess(_data)
          raise NotImplementedError
        end

        class << self
          def register_filters
            @register_filters ||= []
          end

          def run(body)
            register_filters.each do |klass|
              res = klass.preprocess(body)
              body = res if res.is_a?(String)
            end

            body
          end

          def clear
            register_filters.clear
          end
        end
      end
    end
  end
end
