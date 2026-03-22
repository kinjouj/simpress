# frozen_string_literal: true

require "simpress/config"

module Simpress
  class Paginator
    PREFIX_DEFAULT = "/archives/page"
    attr_reader :page

    def initialize(page, maxpage, prefix = PREFIX_DEFAULT)
      raise ArgumentError, "page=#{page} is out of range (maxpage=#{maxpage})" if page <= 0 || (maxpage - page + 1) <= 0

      @page    = page
      @maxpage = maxpage
      @prefix  = prefix
    end

    def previous_page_exist?
      (@page - 1) > 0
    end

    def next_page_exist?
      @page < @maxpage
    end

    def previous_page
      raise "Not Found previous page" unless previous_page_exist?

      @page - 1 > 1 ? "#{@prefix}/#{@page - 1}.html" : File.dirname(first_page)
    end

    def next_page
      raise "Not Found next page" unless next_page_exist?

      "#{@prefix}/#{@page + 1}.html"
    end

    def current_page
      @page > 1 ? "#{@prefix}/#{@page}.html" : first_page
    end

    class << self
      def paginate
        Simpress::Config.instance.paginate || 10
      end

      def calculate_pagesize(array)
        (array.size / paginate.to_f).ceil
      end

      def each_page(posts, prefix = nil)
        raise "ERROR" unless block_given?

        page_size = calculate_pagesize(posts)
        per_page  = paginate
        posts.each_slice(per_page).with_index(1) do |slice_posts, page|
          paginator = prefix ? new(page, page_size, prefix) : new(page, page_size)
          yield slice_posts, paginator
        end
      end
    end

    private

    def first_page
      @prefix == PREFIX_DEFAULT ? "/index.html" : "#{@prefix}/index.html"
    end
  end
end
