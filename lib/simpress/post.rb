# frozen_string_literal: true

require "json"
require "classy_hash"
require "simpress/category"

module Simpress
  class Post
    SCHEMA = {
      id: String,
      title: String,
      date: Time,
      permalink: String,
      categories: [[Simpress::Category]],
      content: String,
      description: String,
      toc: [[String]],
      cover: String,
      published: CH::G.enum(true, false),
      layout: CH::G.enum(:post, :page)
    }.freeze

    attr_accessor :categories
    attr_reader :id,
                :title,
                :content,
                :description,
                :toc,
                :date,
                :permalink,
                :cover,
                :layout,
                :published

    def initialize(params)
      CH.validate(params, SCHEMA, strict: true)
      params.each {|key, value| instance_variable_set("@#{key}", value) }
    end

    def timestamp
      @date.to_i
    end

    def to_json(*)
      as_json(*).to_json
    end

    def as_json(options = {})
      hash = {
        id: @id,
        title: @title,
        description: @description,
        toc: @toc,
        date: @date,
        permalink: @permalink,
        categories: @categories,
        cover: @cover,
        layout: @layout
      }
      hash[:content] = @content if options[:include_content]
      hash
    end

    def to_s
      "#{@title}: #{@permalink}"
    end
  end
end
