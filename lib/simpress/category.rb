# frozen_string_literal: true

require "oj"
require "stringex"

module Simpress
  class Category
    @cache = {}
    attr_reader :key, :name, :count
    attr_accessor :children

    def initialize(name)
      raise "category is empty" if name.nil?

      @key      = name.to_url
      @name     = name
      @count    = 1
      @children = {}
    end

    def increment!
      @count += 1
    end

    def as_json(_options = {})
      { key: @key, name: @name, count: @count, children: @children }
    end

    def to_json(options = {})
      Oj.dump(as_json(options), **options, mode: :compat, **options)
    end

    def self.fetch(name)
      @cache[name.to_s.strip] ||= new(name)
    end

    def self.clear
      @cache.clear
    end

    private_class_method :new
  end
end
