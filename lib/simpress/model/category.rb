# frozen_string_literal: true

require "only_blank"
require "stringex"

module Simpress
  module Model
    class Category
      attr_reader :key, :name
      attr_accessor :count, :children, :moved, :last_update

      def initialize(name)
        raise "category is empty" if name.blank?

        @key      = name.to_url
        @name     = name
        @count    = 1
        @children = {}
        @moved    = false
      end

      def eql?(other)
        @key == other.key
      end

      def hash
        @key.hash
      end

      def to_json(*)
        as_json(*).to_json
      end

      def as_json(_options = {})
        { key: @key, name: @name, count: @count }
      end
    end
  end
end
