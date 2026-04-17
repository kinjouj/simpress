# frozen_string_literal: true

require "stringex"
require "simpress/json"

module Simpress
  class Taxonomy
    class Term
      PERMITTED_JSON_KEYS = [:key, :name, :count, :children].freeze
      DEFAULT_JSON_KEYS   = [:key, :name, :count].freeze
      attr_reader :key, :name, :children, :posts

      def initialize(name, key: nil)
        @key      = key || name.to_url
        @name     = name
        @posts    = []
        @children = []
      end

      def initialize_copy(orig)
        super
        @children = orig.children.map(&:dup)
      end

      def count
        @posts.size
      end

      def as_json(options = {})
        keys = options[:keys] ? PERMITTED_JSON_KEYS & options[:keys] : DEFAULT_JSON_KEYS
        keys.to_h do |key|
          value = public_send(key)
          value = value.map {|v| v.as_json(options) } if key == :children
          [key, value]
        end
      end

      def to_json(options = {})
        Simpress::JSON.dump(as_json(options))
      end

      def eql?(other)
        other.is_a?(Term) && key == other.key && name == other.name
      end
    end
  end
end
