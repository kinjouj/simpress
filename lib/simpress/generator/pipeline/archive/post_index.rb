# frozen_string_literal: true

require "simpress/generator/pipeline/base"
require "simpress/logger"

module Simpress
  module Generator
    module Pipeline
      module Archive
        class PostIndex < Simpress::Generator::Pipeline::Base
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :cover, :description].freeze

          def self.generate_html(posts)
            each_page(posts) do |slice_posts, paginator|
              write_html(paginator.current_page, template: "index", posts: slice_posts, paginator: paginator) do |file|
                Simpress::Logger.verbose("[BUILD ARCHIVE]: #{file}")
              end
            end
          end

          def self.generate_json(posts)
            base_path = path("/archives/page")
            page_size = each_page(posts) do |slice_posts, paginator|
              write_json(base_path.path(paginator.page), slice_posts, keys: DATA_JSON_KEYS) do |file|
                Simpress::Logger.verbose("[BUILD ARCHIVE]: #{file}")
              end
            end

            write_json(base_path.path("/meta.json"), { total_pages: page_size }) do |file|
              Simpress::Logger.verbose("[BUILD ARCHIVE]: #{file}")
            end
          end
        end
      end
    end
  end
end
