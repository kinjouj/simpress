# frozen_string_literal: true

require "simpress/json"

module Simpress
  class Entry
    include Simpress::JSON::Serializable

    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :description, :toc, :cover, :prev, :next].freeze

    attr_reader :id, :title, :date, :permalink, :taxonomies, :description, :layout, :index, :draft, :markdown, :params, :content, :toc, :cover
    attr_accessor :prev, :next

    def initialize(params)
      @params = params
      @id = params[:id]
      @title = params[:title]
      @date = params[:date]
      @permalink = params[:permalink]
      @taxonomies = params[:taxonomies]
      @description = params[:description]
      @cover = params[:cover]
      @layout = params[:layout]
      @index = params[:index]
      @draft = params[:draft]
      @markdown = params[:markdown]
      @content = params[:content]
      @toc = params[:toc]
    end

    def to_h(options = {})
      keys = options[:keys]
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, public_send(key)] }
    end

    class Link
      include Simpress::JSON::Serializable

      attr_reader :id, :title, :permalink

      def self.build(entry)
        return if entry.nil?

        new(entry)
      end

      def initialize(entry)
        @id = entry.id
        @title = entry.title
        @permalink = entry.permalink
      end

      def to_h(_options = {})
        { id: id, title: title, permalink: permalink }
      end

      private_class_method :new
    end
  end
end
