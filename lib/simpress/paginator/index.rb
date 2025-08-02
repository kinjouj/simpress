# frozen_string_literal: true

module Simpress
  module Paginator
    class Index
      PREFIX_DEFAULT = "/archives/page"
      attr_accessor :page

      def initialize(page, maxpage, prefix = PREFIX_DEFAULT)
        raise ArgumentError if !page.positive? || !((maxpage - page) + 1).positive?

        @prefix  = prefix
        @page    = page
        @maxpage = maxpage
      end

      def previous_page_exist?
        (@page - 1).positive?
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
end
