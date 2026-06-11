# frozen_string_literal: true

require "simpress/logger"

module Simpress
  module Parser
    module Markdown
      module Enhancer
        def preprocess(_data)
          raise NotImplementedError
        end

        class << self
          def register_enhancers
            @register_enhancers ||= []
          end

          def extended(klass)
            super
            register_enhancers << klass
            Simpress::Logger.debug("REGISTER FILTER: #{klass}")
          end

          def run(body)
            register_enhancers.each do |klass|
              res  = klass.preprocess(body)
              body = res if res.is_a?(String)
            end

            body
          end

          def clear
            register_enhancers.clear
          end
        end
      end
    end
  end
end
