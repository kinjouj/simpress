# frozen_string_literal: true

require "simpress/json"

module Simpress
  class Post
    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :content, :description, :toc, :cover].freeze
    PERMITTED_PARAMS    = attr_reader :id,
                                      :title,
                                      :date,
                                      :permalink,
                                      :categories,
                                      :content,
                                      :description,
                                      :toc,
                                      :cover,
                                      :layout,
                                      :draft,
                                      :markdown

    def initialize(params)
      params.each {|key, value| instance_variable_set("@#{key}", value) if PERMITTED_PARAMS.include?(key) }
    end

    def timestamp
      @date.to_i
    end

    def to_h(keys: nil)
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, instance_variable_get("@#{key}")] }
    end

    def as_json(options = {})
      to_h(keys: options[:keys] || PERMITTED_JSON_KEYS)
    end

    def to_json(options = {})
      Simpress::JSON.dump(as_json(options))
    end

    def to_s
      "#{@title}: #{@permalink}"
    end
  end
end
