# frozen_string_literal: true

module Simpress
  module Paginator
    def self.builder
      Builder.new
    end
  end

  class Builder
    def initialize
      @index   = 0
      @maxpage = 0
      @prefix  = nil
      @posts   = nil
    end

    def index(index)
      @index = index
      self
    end

    def maxpage(maxpage)
      @maxpage = maxpage
      self
    end

    def prefix(prefix)
      @prefix = prefix
      self
    end

    def posts(posts)
      @posts = posts
      self
    end

    # rubocop:disable Style/RedundantReturn
    def build
      if !@posts.blank?
        return Simpress::Paginator::Post.new(@index, @posts)
      elsif @maxpage.positive?
        argv = [@index, @maxpage]
        argv << @prefix unless @prefix.blank?
        return Simpress::Paginator::Index.new(*argv)
      else
        raise "ERROR"
      end
    end
  end
  # rubocop:enable Style/RedundantReturn

  private_constant :Builder
end
