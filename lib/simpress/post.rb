# frozen_string_literal: true

require "forwardable"
require "simpress/json"
require "simpress/taxonomy"

module Simpress
  class Post
    include Simpress::JSON::Serializable

    PERMITTED_JSON_KEYS = [
      :id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next, :backlinks
    ].freeze

    attr_reader :id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next, :layout, :index, :draft, :markdown, :links, :params
    attr_accessor :backlinks

    class PostLink
      include Simpress::JSON::Serializable
      extend Forwardable

      def_delegators :@post, :id, :title, :permalink

      def initialize(post)
        @post = post
      end

      def to_h(_options = {})
        { id: id, title: title, permalink: permalink }
      end
    end

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
      @links       = params[:links] || []
      @taxonomies  = Simpress::Taxonomy.taxonomies.to_h {|t| [t.name, Array(params[t.name.to_sym]).map {|name| t.term(name) }] }
      @params      = params
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
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, public_send(key)] }
    end

    private

    def summarize(post)
      return nil if post.nil?

      PostLink.new(post)
    end
  end
end
