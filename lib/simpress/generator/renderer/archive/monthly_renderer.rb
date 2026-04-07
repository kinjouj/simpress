# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      module Archive
        class MonthlyRenderer < BaseRenderer
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :cover, :description].freeze

          def self.generate_html(monthly_archives)
            monthly_archives.each do |date, posts_by_monthly|
              year   = date.year
              month  = date.month
              key    = "#{year}/#{month}"
              prefix = "/archives/#{year}/#{month.to_s.rjust(2, '0')}"
              each_page(posts_by_monthly, prefix) do |slice_posts, paginator|
                path = paginator.current_page
                write_html(path, template: "index", key: key, posts: slice_posts, paginator: paginator) do |file_path|
                  Simpress::Logger.info("[BUILD ARCHIVE]: #{file_path}")
                end
              end
            end
          end

          def self.generate_json(monthly_posts)
            monthly_posts.each do |date, posts_by_monthly|
              year      = date.year
              month     = date.month
              base_path = uri("/archives/#{year}/#{month.to_s.rjust(2, '0')}")
              page_size = each_page(posts_by_monthly) do |slice_posts, paginator|
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
end
