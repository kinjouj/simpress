# frozen_string_literal: true

require "simpress/json"
require "simpress/post/link"
require "simpress/taxonomy"

module Simpress
  class Post
    include Simpress::JSON::Serializable

    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next, :backlinks].freeze

    attr_reader :id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :layout, :index, :draft, :markdown, :params
    attr_accessor :prev, :next, :backlinks

    def initialize(params)
      @params      = params
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
      @taxonomies  = Simpress::Taxonomy.resolve(params)
    end

    def register_taxonomies!
      return if @draft

      Simpress::Taxonomy.register(@taxonomies, self)
    end

    def to_h(options = {})
      keys = options[:keys]
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, public_send(key)] }
    end
  end
end
