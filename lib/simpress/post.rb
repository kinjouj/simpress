# frozen_string_literal: true

require "oj"
require "uri"
require "simpress/category"

module Simpress
  class Post
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

    REGEX_EXT = /\.[^.]+\Z/

    def initialize(params)
      params.each {|key, value| instance_variable_set("@#{key}", value) }
    end

    def permalink(ext = nil)
      ext.nil? ? @permalink : @permalink.sub(REGEX_EXT, ext)
    end

    def timestamp
      @date.to_i
    end

    def canonical
      @canonical ||= [Simpress::Config.instance.host.chomp("/"), @permalink].join
    end

    def as_json(options = {})
      hash = {
        id: @id,
        title: @title,
        date: @date,
        permalink: permalink,
        source: permalink(".json"),
        categories: @categories,
        cover: @cover,
        description: @description,
        toc: @toc,
        content: @content
      }

      options[:keys] ? hash.slice(*Array(options[:keys])) : hash
    end

    def to_json(options = {})
      Oj.dump(as_json(options), mode: :compat)
    end

    def to_s
      "#{@title}: #{@permalink}"
    end
  end
end
