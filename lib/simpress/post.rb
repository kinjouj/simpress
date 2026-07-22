# frozen_string_literal: true

require "simpress/json"
require "simpress/taxonomy"

module Simpress
  class Post
    include Simpress::JSON::Serializable

    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :adjacent].freeze

    attr_reader :id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :layout, :index, :draft, :markdown
    attr_accessor :adjacent

    def initialize(params)
      @id          = params[:id]
      @title       = params[:title]
      @date        = params[:date]
      @permalink   = params[:permalink]
      @content     = params[:content]
      @description = params[:description]
      @toc         = params[:toc]
      @cover       = params[:cover]
      @layout      = params[:layout]
      @index       = params[:index]
      @draft       = params[:draft]
      @markdown    = params[:markdown]
      @adjacent    = nil
      @taxonomies  = build_taxonomies(params)
    end

    def register_taxonomies!
      return if @draft

      @taxonomies.each_value {|terms| terms.each {|term| term.posts << self } }
    end

    def to_h(options = {})
      keys = options[:keys]
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, instance_variable_get("@#{key}")] }
    end

    class Adjacent
      include Simpress::JSON::Serializable

      Summary = Data.define(:id, :title, :permalink)

      attr_reader :prev, :next

      def self.summarize(post)
        return nil if post.nil?

        Summary.new(id: post.id, title: post.title, permalink: post.permalink)
      end

      def initialize(newer_post, older_post)
        @prev = self.class.summarize(older_post)
        @next = self.class.summarize(newer_post)
      end

      def to_h(*)
        { prev: @prev, next: @next }
      end
    end

    private

    def build_taxonomies(params)
      Simpress::Taxonomy.taxonomies.to_h do |taxonomy|
        terms = Array(params[taxonomy.name.to_sym]).map {|name| taxonomy.term(name) }
        [taxonomy.name, terms]
      end
    end
  end
end
