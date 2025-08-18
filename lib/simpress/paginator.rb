# frozen_string_literal: true

module Simpress
  module Paginator
    def self.builder
      Builder.new
    end
  end

  class Builder
    def initialize
      @type    = nil
      @page    = 0
      @maxpage = 0
      @prefix  = nil
      @posts   = nil
    end

    def page(page)
      @page = page
      self
    end

    def maxpage(maxpage)
      @maxpage = maxpage
      @type    = :index
      self
    end

    def prefix(prefix)
      @prefix = prefix
      @type   = :index
      self
    end

    def posts(posts)
      @posts = posts
      @type  = :post
      self
    end

    # rubocop:disable Style/RedundantReturn
    def build
      if @type == :index && @maxpage.positive?
        if @prefix.blank? # rubocop:disable Style/GuardClause
          return Simpress::Paginator::Index.new(@page, @maxpage)
        else
          return Simpress::Paginator::Index.new(@page, @maxpage, @prefix)
        end
      elsif @type == :post && !@posts.blank?
        return Simpress::Paginator::Post.new(@page, @posts)
      else
        raise "ERROR"
      end
    end
  end
  # rubocop:enable Style/RedundantReturn

  private_constant :Builder
end
