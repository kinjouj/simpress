# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      module Archive
        class PostIndexRenderer < BaseRenderer
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :cover, :description].freeze

          def self.generate_html(posts)
            each_page(posts) do |slice_posts, paginator|
              context = build_context(posts: slice_posts, paginator: paginator)
              write_html(paginator.current_page, template: "index", context: context) do |file_path|
                Simpress::Logger.info("create archive: #{file_path}")
              end
            end
          end

          def self.generate_json(posts)
            page_size = each_page(posts) do |slice_posts, paginator|
              write_json(uri("/archives/page").path(paginator.page).build, slice_posts, keys: DATA_JSON_KEYS) do |file_path|
                Simpress::Logger.info("create archive: #{file_path}")
              end
            end

            write_json("/archives/page/meta.json", { total_pages: page_size }) do |file_path|
              Simpress::Logger.info("create archive: #{file_path}")
            end
          end
        end
      end
    end
  end
end
