# frozen_string_literal: true

require "simpress/config"
require "simpress/json"

module Simpress
  class Post
    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :content, :description, :toc, :cover, :categories].freeze
    DEFAULT_JSON_KEYS   = PERMITTED_JSON_KEYS
    REGEX_EXT = /\.[^.]+\Z/

    attr_accessor :categories
    attr_reader :id,
                :title,
                :date,
                :content,
                :description,
                :toc,
                :cover,
                :layout,
                :draft,
                :markdown

    def initialize(params)
      params.each {|key, value| instance_variable_set("@#{key}", value) }
    end

    def permalink(ext = nil)
      return @permalink if ext.nil?

      @permalink.sub(REGEX_EXT, ext)
    end

    def timestamp
      @date.to_i
    end

    def canonical
      @canonical ||= "#{Simpress::Config.instance.host.chomp('/')}#{@permalink}"
    end

    def as_json(options = {})
      keys = (options[:keys] || DEFAULT_JSON_KEYS) & PERMITTED_JSON_KEYS
      keys.to_h {|key| [key, instance_variable_get("@#{key}")] }
    end

    def to_json(options = {})
      Simpress::JSON.dump(as_json(options))
    end

    def to_s
      "#{@title}: #{@permalink}"
    end
  end
end
