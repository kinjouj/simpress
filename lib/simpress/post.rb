# frozen_string_literal: true

require "json"
require "pathname"
require "uri"
require "simpress/category"

module Simpress
  class Post
    attr_accessor :categories
    attr_reader :id,
                :title,
                :date,
                :permalink,
                :content,
                :description,
                :toc,
                :cover,
                :layout,
                :published,
                :markdown

    def initialize(params)
      params.each {|key, value| instance_variable_set("@#{key}", value) }
    end

    def timestamp
      @date.to_i
    end

    def canonical
      [Simpress::Config.instance.host.chomp("/"), permalink].join("")
    end

    def rebase(ext)
      Pathname.new(permalink).sub_ext(ext).to_s
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
        cover: @cover
      }
      hash[:content] = @content if options[:include_content]
      hash
    end

    def to_json(*)
      as_json(*).to_json
    end

    def to_s
      "#{@title}: #{@permalink}"
    end
  end
end
