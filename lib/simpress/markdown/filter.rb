# frozen_string_literal: true

module Simpress
  module Markdown
    module Filter
      def preprocess(_data)
        raise "ERROR"
      end

      class << self
        def extended(klass)
          super
          Thread.current[:filter_classes] ||= []
          Thread.current[:filter_classes] << klass
        end

        def run(body)
          data = body.dup
          (Thread.current[:filter_classes] || []).each do |klass|
            res  = klass.preprocess(data)
            data = res if res.is_a?(String)
          end

          data
        end

        def clear
          Thread.current[:filter_classes] = nil
        end
      end
    end
  end
end
