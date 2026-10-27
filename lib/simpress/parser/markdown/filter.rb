# frozen_string_literal: true

module Simpress
  module Parser
    module Markdown
      module Filter
        def preprocess(data)
          data
        end

        def postprocess(data)
          data
        end

        class << self
          def register_filters
            @register_filters ||= []
          end

          def preprocess(body)
            apply(body) {|klass, data| klass.preprocess(data) }
          end

          def postprocess(body)
            apply(body) {|klass, data| klass.postprocess(data) }
          end

          def clear
            register_filters.clear
          end

          private

          def apply(body)
            register_filters.each do |klass|
              res = yield(klass, body)
              body = res if res.is_a?(String)
            end

            body
          end
        end
      end
    end
  end
end
