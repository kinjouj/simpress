# frozen_string_literal: true

require "erubis"
require "singleton"

module Simpress
  class Context < Erubis::Context
    include Singleton

    class << self
      def [](key)
        instance[key.to_sym] or raise KeyError, "'#{key}' missing"
      end

      def []=(key, value)
        instance[key.to_sym] = value
      end

      def update(obj)
        instance.update(obj)
      end

      def clear
        Singleton.__init__(Simpress::Context)
      end
    end
  end
end
