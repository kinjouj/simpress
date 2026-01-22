# frozen_string_literal: true

require "oj"
require "simpress/generator/renderer/index_renderer"
require "simpress/logger"
require "simpress/paginator"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class MonthlyIndexRenderer
        def self.generate_html(monthly_archives)
          monthly_archives.each do |date, posts_by_monthly|
            year   = date.year
            month  = date.month
            month2 = format("%02d", month)
            paginator = Simpress::Paginator.builder
                                           .maxpage(Simpress::Paginator.calculate_pagesize(posts_by_monthly))
                                           .page(1)
                                           .prefix("/archives/#{year}/#{month2}")
                                           .build

            Simpress::Generator::Renderer::IndexRenderer.generate_html(posts_by_monthly, paginator, "#{year}/#{month}")
          end
        end

        def self.generate_json(monthly_posts)
          monthly_posts.each do |date, posts|
            file_path = File.join("/archives", "#{date.strftime('%Y/%02m')}.json")
            Simpress::Writer.write(file_path, Oj.dump(posts, mode: :json)) do |_|
              Simpress::Logger.info("create archive: #{file_path}")
            end
          end
        end
      end
    end
  end
end
