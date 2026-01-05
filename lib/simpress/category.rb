# frozen_string_literal: true

require "only_blank"
require "stringex"

module Simpress
  class Category
    attr_reader :key, :name
    attr_accessor :count, :children, :last_update

    def initialize(name)
      raise "category is empty" if name.blank?

      @key      = name.to_url
      @name     = name
      @count    = 1
      @children = {}
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
      { key: @key, name: @name, count: @count, children: @children }
    end
  end
end
