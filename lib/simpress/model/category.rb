# frozen_string_literal: true

module Simpress
  module Model
    class Category
      include Jsonable
      attr_reader :name, :count
      attr_accessor :children, :moved, :last_update

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

      def increment
        @count += 1
      end

      def eql?(other)
        @name.to_url == other.to_url
      end

      def hash
        @name.to_url.hash
      end

      def exclude_jsonable
        [ :moved ]
      end
    end
  end
end
