# frozen_string_literal: true

require "simpress/generator/renderer/index_renderer"
require "simpress/generator/renderer/category_index_renderer"
require "simpress/generator/renderer/permalink_renderer"
require "simpress/generator/renderer/page_renderer"
require "simpress/generator/renderer/monthly_index_renderer"
require "simpress/generator/renderer/categories_renderer"
require "simpress/generator/renderer/page_info_renderer"

module Simpress
  module Generator
    module Json
      def self.generate(posts, pages, categories)
        category_posts = Hash.new {|h, k| h[k] = [] }
        monthly_posts  = Hash.new {|h, k| h[k] = [] }
        sliced_posts   = posts.each_slice(10).to_a
        sliced_posts.each.with_index(1) do |sliced_post, page|
          archives = []
          sliced_post.each do |post|
            post.categories.map! do |category|
              category_posts[category] << post
              categories[category.key.to_sym]
            end

            Simpress::Generator::Renderer::PermalinkRenderer.generate_json(post)

            date = Time.new(post.date.year, post.date.month, 1)
            monthly_posts[date] << post
            archives << post
          end

          Simpress::Generator::Renderer::IndexRenderer.generate_json(archives, page)
        end

        Simpress::Generator::Renderer::PageRenderer.generate_json(pages)
        Simpress::Generator::Renderer::CategoryIndexRenderer.generate_json(category_posts)
        Simpress::Generator::Renderer::MonthlyIndexRenderer.generate_json(monthly_posts)
        Simpress::Generator::Renderer::CategoriesRenderer.generate_json(categories)
        Simpress::Generator::Renderer::PageInfoRenderer.generate_json(sliced_posts.size)
      end
    end
  end
end
