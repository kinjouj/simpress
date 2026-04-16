# frozen_string_literal: true

module Simpress
  class Paginator
    PREFIX_DEFAULT = "/archives/page"
    attr_reader :page, :maxpage, :prefix

    def initialize(page:, maxpage:, prefix: nil)
      raise ArgumentError, "page=#{page} is out of range (maxpage=#{maxpage})" if page <= 0 || (maxpage - page + 1) <= 0

      @page    = page
      @maxpage = maxpage
      @prefix  = prefix || PREFIX_DEFAULT
    end

    def previous_page_exist?
      (@page - 1) > 0
    end

    def next_page_exist?
      @page < @maxpage
    end

    def previous_page
      raise "Not Found previous page" unless previous_page_exist?

      page_path(@page - 1)
      @page - 1 > 1 ? page_path(@page - 1) : File.dirname(page_path(1))
    end

    def next_page
      raise "Not Found next page" unless next_page_exist?

      page_path(@page + 1)
    end

    def current_page
      page_path(@page)
    end

    private

    def page_path(page)
      return @prefix == PREFIX_DEFAULT ? "/index.html" : "#{@prefix}/index.html" if page == 1

      "#{@prefix}/#{page}.html"
    end
  end
end
