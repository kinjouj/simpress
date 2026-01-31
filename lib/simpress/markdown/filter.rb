# frozen_string_literal: true

require "simpress/logger"

module Simpress
  module Markdown
    module Filter
      def preprocess(_data)
        raise "ERROR"
      end

      class << self
        def classes
          @classes ||= []
        end

        def extended(klass)
          super
          classes << klass
          Simpress::Logger.debug("REGISTER FILTER: #{klass}")
        end

        def run(body)
          data = body
          classes.each do |klass|
            res  = klass.preprocess(data)
            data = res if res.is_a?(String)
          end

          data
        end

        def clear
          @classes = []
        end
      end
    end
  end
end
