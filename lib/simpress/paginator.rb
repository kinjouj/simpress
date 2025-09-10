# frozen_string_literal: true

module Simpress
  module Paginator
    def self.builder
      Builder.new
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

      def build
        if !@posts.blank?
          Simpress::Paginator::Post.new(@index, @posts)
        elsif @maxpage.positive?
          args = [@index, @maxpage]
          args << @prefix unless @prefix.blank?
          Simpress::Paginator::Index.new(*args)
        else
          raise "ERROR"
        end
      end
    end
  end
end
