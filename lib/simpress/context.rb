# frozen_string_literal: true

require "singleton"

module Simpress
  class Context
    include Singleton

    def initialize
      @data = {}
    end

    def [](key)
      @data.fetch(key.to_sym) { raise KeyError, "key not found: #{key}" }
    end

    def []=(key, value)
      @data[key.to_sym] = value
    end

    def update(obj)
      obj.each {|k, v| self[k] = v }
    end

    def to_h
      @data.dup
    end

    def clear
      @data.clear
    end

    class << self
      def [](key)
        instance[key]
      end

      def []=(key, value)
        instance[key] = value
      end

      def update(obj) = instance.update(obj)

      def to_h = instance.to_h

      def clear = instance.clear
    end
  end
end
