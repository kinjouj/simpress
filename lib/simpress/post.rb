# frozen_string_literal: true

require "simpress/json"

module Simpress
  class Post
    PERMITTED_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :content, :description, :toc, :cover].freeze
    PERMITTED_PARAMS    = attr_reader :id,
                                      :title,
                                      :date,
                                      :permalink,
                                      :categories,
                                      :content,
                                      :description,
                                      :toc,
                                      :cover,
                                      :layout,
                                      :index,
                                      :draft,
                                      :markdown

    def initialize(params)
      @id          = params[:id]
      @title       = params[:title]
      @date        = params[:date]
      @permalink   = params[:permalink]
      @categories  = params[:categories]
      @content     = params[:content]
      @description = params[:description]
      @toc         = params[:toc]
      @cover       = params[:cover]
      @layout      = params[:layout]
      @index       = params[:index]
      @draft       = params[:draft]
      @markdown    = params[:markdown]
    end

    def timestamp
      @date.to_i
    end

    def to_h(options = {})
      keys = options[:keys]
      (keys ? PERMITTED_JSON_KEYS & keys : PERMITTED_JSON_KEYS).to_h {|key| [key, instance_variable_get("@#{key}")] }
    end

    def as_json(options = {})
      to_h(options)
    end

    def to_json(options = {})
      Simpress::JSON.dump(as_json(options))
    end
  end
end
