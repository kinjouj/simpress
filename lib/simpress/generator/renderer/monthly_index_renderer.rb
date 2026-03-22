# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/paginator"

module Simpress
  module Generator
    module Renderer
      class MonthlyIndexRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :cover, :description].freeze

        def self.generate_html(monthly_archives)
          monthly_archives.each do |date, posts_by_monthly|
            year   = date.year
            month  = date.month
            key    = "#{year}/#{month}"
            prefix = "/archives/#{year}/#{month.to_s.rjust(2, '0')}"
            Simpress::Paginator.each_page(posts_by_monthly, prefix) do |slice_posts, paginator|
              context = build_context(key: key, posts: slice_posts, paginator: paginator)
              write_html(paginator.current_page, template: "index", context: context) do |file_path|
                logger_info("create archive: #{file_path}")
              end
            end
          end
        end

        def self.generate_json(monthly_posts)
          monthly_posts.each do |date, posts_by_monthly|
            year  = date.year
            month = date.month.to_s.rjust(2, "0")
            write_json(uri("/archives").path(year).path(month), posts_by_monthly, keys: DATA_JSON_KEYS) do |file_path|
              logger_info("create archive: #{file_path}")
            end
          end
        end
      end
    end
  end
end
