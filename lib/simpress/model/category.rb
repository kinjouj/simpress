# frozen_string_literal: true

module Simpress
  module Model
    class Category
      include Jsonable

      attr_reader :key, :name
      attr_accessor :count, :children, :moved, :last_update

      def initialize(name)
        raise "category is empty" if name.blank?

        @key      = Simpress::Model::Category.to_url(name)
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

      # :nocov:
      def exclude_jsonable
        [:moved, :children]
      end
      # :nocov:

      def self.to_url(str)
        str.to_url
      end
    end
  end
end
