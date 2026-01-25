# frozen_string_literal: true

require "classy_hash"
require "json"
require "natto"
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
      toc: [[:optional, [[Integer, String]]]],
      cover: String,
      layout: CH::G.enum(:post, :page),
      published: CH::G.enum(true, false),
      markdown: String
    }.freeze

    NATTO_REGEX = /\A(?<surface>[^\t]{3,})\t名詞,(?>固有名詞|一般(?=.*\p{Han}))/
    NATTO = Natto::MeCab.new

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
      CH.validate(params, SCHEMA, strict: true, verbose: true)
      params.each {|key, value| instance_variable_set("@#{key}", value) }
    end

    def timestamp
      @date.to_i
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

    def to_json(*)
      as_json(*).to_json
    end

    def extract_keywords
      keywords = Set.new
      NATTO.parse([@title, @markdown].compact.join(" ")).each_line do |line|
        match = line.match(NATTO_REGEX)
        keywords << match[:surface] if match
      end

      keywords.to_a
    end

    def to_s
      "#{@title}: #{@permalink}"
    end
  end
end
