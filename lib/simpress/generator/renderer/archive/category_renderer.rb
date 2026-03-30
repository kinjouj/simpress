# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      module Archive
        class CategoryRenderer < BaseRenderer
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :cover, :description].freeze

          def self.generate_html(category_posts)
            category_posts.each do |category, posts|
              prefix = "/archives/category/#{category.key}"
              each_page(posts, prefix) do |slice_posts, paginator|
                path = paginator.current_page
                write_html(path, template: "index", key: category.key, posts: slice_posts, paginator: paginator) do |file_path|
                  Simpress::Logger.info("create category index: #{file_path}")
                end
              end
            end
          end

          def self.generate_json(category_posts)
            category_posts.each do |category, posts|
              base_path = uri("/archives/category/#{category.key}")
              page_size = each_page(posts) do |slice_posts, paginator|
                write_json(base_path.path(paginator.page), slice_posts, keys: DATA_JSON_KEYS) do |file_path|
                  Simpress::Logger.info("create category: #{file_path}")
                end
              end

              write_json(base_path.path("/meta.json"), { total_pages: page_size }) do |file_path|
                Simpress::Logger.info("create archive: #{file_path}")
              end
            end
          end
        end
      end
    end
  end
end
