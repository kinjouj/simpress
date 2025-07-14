# frozen_string_literal: true

module Simpress
  class Context < Erubis::Context
    include Singleton

    class << self
      def [](key)
        instance[key.to_sym] or raise "#{key} missing"
      end

      def update(obj)
        raise ArgumentError unless obj.is_a?(Hash)

        instance.update(obj)
      end

      def clear
        Singleton.__init__(Simpress::Context)
      end
    end
  end
end
