# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/paginator"

module Simpress
  module Generator
    module Renderer
      class CategoryIndexRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :cover, :description].freeze

        def self.generate_html(category_posts)
          category_posts.each do |category, posts|
            prefix = "/archives/category/#{category.key}"
            Simpress::Paginator.each_page(posts, prefix) do |slice_posts, paginator|
              context = build_context(key: category.name, posts: slice_posts, paginator: paginator)
              write_html(paginator.current_page, template: "index", context: context) do |file_path|
                logger_info("create category index: #{file_path}")
              end
            end
          end
        end

        def self.generate_json(category_posts)
          category_posts.each do |category, posts|
            write_json(uri("/archives/category").path(category.key), posts, keys: DATA_JSON_KEYS) do |file_path|
              logger_info("create category: #{file_path}")
            end
          end
        end
      end
    end
  end
end
