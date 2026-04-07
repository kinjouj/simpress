# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      module Archive
        class PostIndexRenderer < BaseRenderer
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :cover, :description].freeze

          def self.generate_html(posts)
            each_page(posts) do |slice_posts, paginator|
              write_html(paginator.current_page, template: "index", posts: slice_posts, paginator: paginator) do |file_path|
                Simpress::Logger.info("[BUILD ARCHIVE]: #{file_path}")
              end
            end
          end

          def self.generate_json(posts)
            base_path = uri("/archives/page")
            page_size = each_page(posts) do |slice_posts, paginator|
              write_json(base_path.path(paginator.page), slice_posts, keys: DATA_JSON_KEYS) do |file_path|
                Simpress::Logger.info("[BUILD ARCHIVE]: #{file_path}")
              end
            end

            write_json(base_path.path("/meta.json"), { total_pages: page_size }) do |file_path|
              Simpress::Logger.info("[BUILD ARCHIVE]: #{file_path}")
            end
          end
        end
      end
    end
  end
end
