# frozen_string_literal: true

module Simpress
  module Model
    class Category
      include Jsonable
      attr_reader :name
      attr_accessor :count, :children, :moved, :last_update

      def initialize(name)
        raise "category is empty" if !name || name.empty?

        @name     = name
        @key      = name.to_url
        @count    = 1
        @children = {}
        @moved    = false
      end

      def to_url
        @key
      end

      def eql?(other)
        @key == other.to_url
      end

      def hash
        @key.hash
      end

      def exclude_jsonable
        [ :moved ]
      end
    end
  end
end
