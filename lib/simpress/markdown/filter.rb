# frozen_string_literal: true

module Simpress
  module Markdown
    module Filter
      def preprocess(_data)
        raise "ERROR"
      end

      class << self
        KEY = :simpress_filter_classes

        def extended(klass)
          super
          (Thread.current[KEY] ||= Set.new) << klass
          Simpress::Logger.debug("REGISTER FILTER: #{klass}")
        end

        def run(body)
          data = body
          (Thread.current[KEY] || []).each do |klass|
            res  = klass.preprocess(data.freeze)
            data = res if res.is_a?(String)
          end

          data
        end

        def clear
          Thread.current[KEY] = nil
        end
      end
    end
  end
end
