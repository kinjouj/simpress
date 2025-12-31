# frozen_string_literal: true

require "json"
require "simpress/generator/json/index_renderer"
require "simpress/generator/json/categories_renderer"
require "simpress/generator/json/category_index_renderer"
require "simpress/generator/json/monthly_index_renderer"
require "simpress/generator/json/page_info_renderer"
require "simpress/generator/json/permalink_renderer"

module Simpress
  module Generator
    module Json
      def self.generate(posts, _, categories)
        category_posts = {}
        monthly_posts  = {}
        sliced_posts   = posts.each_slice(10).to_a
        sliced_posts.each.with_index(1) do |sliced_post, page|
          archives = []
          sliced_post.each do |post|
            post.categories.map! do |category|
              (category_posts[category.key] ||= []) << post
              categories[category.key]
            end

            Simpress::Generator::Json::PermalinkRenderer.generate(post)

            date = Time.new(post.date.year, post.date.month, 1)
            (monthly_posts[date] ||= []) << post
            archives << post
          end

          Simpress::Generator::Json::IndexRenderer.generate(archives, page)
        end

        Simpress::Generator::Json::CategoryIndexRenderer.generate(category_posts)
        Simpress::Generator::Json::MonthlyIndexRenderer.generate(monthly_posts)
        Simpress::Generator::Json::CategoriesRenderer.generate(categories)
        Simpress::Generator::Json::PageInfoRenderer.generate(sliced_posts.size)
      end
    end
  end
end
