# frozen_string_literal: true

require "simpress/json"
require "simpress/taxonomy"

module Simpress
  class Post
    include Simpress::JSON::Serializable

    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next].freeze
    PostLink = Data.define(:id, :title, :permalink)

    attr_reader :id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next,
                :layout, :index, :draft, :markdown

    def initialize(params)
      @id          = params[:id]
      @title       = params[:title]
      @date        = params[:date]
      @permalink   = params[:permalink]
      @content     = params[:content]
      @description = params[:description]
      @toc         = params[:toc]
      @cover       = params[:cover]
      @prev        = nil
      @next        = nil
      @layout      = params[:layout]
      @index       = params[:index]
      @draft       = params[:draft]
      @markdown    = params[:markdown]
      @taxonomies  = build_taxonomies(params)
    end

    def register_taxonomies!
      return if @draft

      @taxonomies.each_value {|terms| terms.each {|term| term.posts << self } }
    end

    def set_adjacent!(newer_post, older_post)
      @prev = summarize(older_post)
      @next = summarize(newer_post)
    end

    def to_h(options = {})
      keys = options[:keys]
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, instance_variable_get("@#{key}")] }
    end

    private

    def summarize(post)
      return nil if post.nil?

      PostLink.new(id: post.id, title: post.title, permalink: post.permalink)
    end

    def build_taxonomies(params)
      Simpress::Taxonomy.taxonomies.to_h do |taxonomy|
        terms = Array(params[taxonomy.name.to_sym]).map {|name| taxonomy.term(name) }
        [taxonomy.name, terms]
      end
    end
  end
end
