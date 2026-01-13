# frozen_string_literal: true

require "json"
require "stringex"

module Simpress
  class Category
    @cache = {}
    attr_reader :key, :name
    attr_accessor :count, :children, :last_update

    def initialize(name)
      raise "category is empty" if name.nil?

      @key      = name.to_url
      @name     = name
      @count    = 1
      @children = {}
    end

    def to_json(*)
      as_json(*).to_json
    end

    def as_json(_options = {})
      { key: @key, name: @name, count: @count, children: @children }
    end

    def self.fetch(name)
      @cache[name] ||= new(name)
    end

    private_class_method :new
  end
end
