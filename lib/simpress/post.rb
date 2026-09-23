# frozen_string_literal: true

require "simpress/json"
require "simpress/parser/markdown/processor"
require "simpress/post/link"
require "simpress/taxonomy"

module Simpress
  class Post
    include Simpress::JSON::Serializable

    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next].freeze
    DEFAULT_COVER = "/images/no_image.webp"
    DESC_REGEX = %r{<p[^>]*>(.*?)</p>}m

    attr_reader :id, :title, :date, :permalink, :taxonomies, :description, :layout, :index, :draft, :markdown, :params, :content, :toc, :links, :cover
    attr_accessor :prev, :next, :backlinks

    def initialize(params)
      @params = params
      @id = params[:id]
      @title = params[:title]
      @date = params[:date]
      @permalink = params[:permalink]
      @description = params[:description]
      @cover = params[:cover]
      @layout = params[:layout]
      @index = params[:index]
      @draft = params[:draft]
      @markdown = params[:markdown]
      @taxonomies = Simpress::Taxonomy.resolve(params)
    end

    def load!
      return if @content

      result = Simpress::Parser::Markdown::Processor.render(@markdown)
      @content = result.content
      @toc = result.toc
      @links = result.links
      @cover ||= result.cover || DEFAULT_COVER
      @description ||= @content[DESC_REGEX, 1].to_s.gsub(/<[^>]*>?/, "").strip
    end

    def to_h(options = {})
      keys = options[:keys]
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, public_send(key)] }
    end
  end
end
