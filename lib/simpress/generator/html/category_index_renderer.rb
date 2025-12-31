# frozen_string_literal: true

require "simpress/paginator"
require "simpress/generator/html/index_renderer"

module Simpress
  module Generator
    module Html
      module CategoryIndexRenderer
        def self.generate(category_posts)
          category_posts.each do |category, posts|
            posts.sort_by! { |v| -v.date.to_time.to_i }
            paginator = Simpress::Paginator.builder
                                           .maxpage(Simpress::Paginator.calculate_pagesize(posts))
                                           .page(1)
                                           .prefix("/archives/category/#{category.key}")
                                           .build

            IndexRenderer.generate(posts, paginator, category.name)
          end
        end
      end
    end
  end
end
