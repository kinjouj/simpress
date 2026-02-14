# frozen_string_literal: true

require "json"
require "simpress/paginator"
require "simpress/generator/renderer/index_renderer"

module Simpress
  module Generator
    module Renderer
      class CategoryIndexRenderer
        def self.generate_html(category_posts)
          category_posts.each do |category, posts|
            posts.sort_by! {|v| -v.timestamp }
            paginator = Simpress::Paginator.builder
                                           .maxpage(Simpress::Paginator.calculate_pagesize(posts))
                                           .page(1)
                                           .prefix("/archives/category/#{category.key}")
                                           .build

            Simpress::Generator::Renderer::IndexRenderer.generate_html(posts, paginator, category.name)
          end
        end

        def self.generate_json(category_posts)
          category_posts.each do |category, posts|
            posts.sort_by! {|v| -v.timestamp }
            file_path = File.join("/archives/category", "#{category.key}.json")
            Simpress::Writer.write(file_path, posts.to_json)
            Simpress::Logger.info("create category: #{file_path}")
          end
        end
      end
    end
  end
end
