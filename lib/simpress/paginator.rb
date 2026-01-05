# frozen_string_literal: true

require "only_blank"
require "simpress/config"
require "simpress/paginator/index"
require "simpress/paginator/post"

module Simpress
  module Paginator
    class << self
      def builder
        Builder.new
      end

      def paginate
        Simpress::Config.instance.paginate || 10
      end

      def calculate_pagesize(array)
        array.size.quo(paginate).ceil
      end
    end

    class Builder
      def maxpage(maxpage)
        IndexPaginatorBuilder.new(maxpage)
      end

      def posts(posts)
        PostPaginatorBuilder.new(posts)
      end

      def build
        raise NotImplementedError
      end

      class IndexPaginatorBuilder
        def initialize(maxpage)
          @maxpage = maxpage
        end

        def page(page)
          @page = page
          self
        end

        def prefix(prefix)
          @prefix = prefix
          self
        end

        def build
          @page ||= 1
          args = [@page, @maxpage]
          args << @prefix unless @prefix.blank?
          Simpress::Paginator::Index.new(*args)
        end
      end

      class PostPaginatorBuilder
        def initialize(posts)
          @posts = posts
        end

        def index(index)
          @index = index
          self
        end

        def build
          @index ||= 0
          Simpress::Paginator::Post.new(@index, @posts)
        end
      end
    end
  end
end
