# frozen_string_literal: true

require "stringex"
require "simpress/json"

module Simpress
  class Category
    PERMITTED_JSON_KEYS = [:key, :name, :count, :children].freeze
    DEFAULT_JSON_KEYS   = [:key, :name].freeze

    attr_reader :key, :name, :count, :children

    @cache = {}

    def initialize(name)
      @key      = name.to_url
      @name     = name
      @count    = 1
      @children = {}
    end

    def increment!
      @count += 1
    end

    def as_json(options = {})
      keys = options[:keys] ? PERMITTED_JSON_KEYS & options[:keys] : DEFAULT_JSON_KEYS
      keys.to_h do |key|
        value = instance_variable_get("@#{key}")
        value = value.transform_values {|v| v.as_json(options) } if key == :children
        [key, value]
      end
    end

    def to_json(options = {})
      Simpress::JSON.dump(as_json(options))
    end

    def self.fetch(name)
      @cache[name] ||= new(name)
    end

    def self.clear
      @cache.clear
    end

    private_class_method :new
  end
end
