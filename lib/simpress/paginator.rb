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

      @page - 1 > 1 ? "#{@prefix}/#{@page - 1}.html" : File.dirname(first_page)
    end

    def next_page
      raise "Not Found next page" unless next_page_exist?

      "#{@prefix}/#{@page + 1}.html"
    end

    def current_page
      @page > 1 ? "#{@prefix}/#{@page}.html" : first_page
    end

    private

    def first_page
      @prefix == PREFIX_DEFAULT ? "/index.html" : "#{@prefix}/index.html"
    end
  end
end
