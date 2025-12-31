# frozen_string_literal: true

require "only_blank"

module Simpress
  module Paginator
    class Post
      def initialize(index, reversed_array)
        raise ArgumentError unless index.between?(0, reversed_array.size - 1)

        next_post, prev_post = array_around_by_index(reversed_array, index)
        @previous_page = prev_post
        @next_page     = next_post
      end

      def previous_page_exist?
        !@previous_page.blank?
      end

      def next_page_exist?
        !@next_page.blank?
      end

      def previous_page
        raise "Not Found previous page" unless previous_page_exist?

        @previous_page
      end

      def next_page
        raise "Not Found next page" unless next_page_exist?

        @next_page
      end

      private

      def array_around_by_index(arr, index)
        prev_post = index.positive? ? arr[index - 1] : nil
        next_post = arr[index + 1] || nil
        [ prev_post, next_post ]
      end
    end
  end
end
