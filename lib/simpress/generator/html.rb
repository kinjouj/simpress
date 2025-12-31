# frozen_string_literal: true

require "simpress/generator/html/category_index_renderer"
require "simpress/generator/html/index_renderer"
require "simpress/generator/html/monthly_index_renderer"
require "simpress/generator/html/page_renderer"
require "simpress/generator/html/permalink_renderer"
require "simpress/paginator"

module Simpress
  module Generator
    module Html
      def self.generate(posts, pages, _)
        paginate          = Simpress::Paginator.paginate
        page_size         = Simpress::Paginator.calculate_pagesize(posts)
        monthly_archives  = {}
        category_posts    = {}
        posts.each_slice(paginate).each.with_index do |slice_posts, page|
          archives = []
          slice_posts.each.with_index do |post, index|
            post.categories.each do |category|
              (category_posts[category] ||= []) << post
            end

            position  = (page * paginate) + index
            paginator = Simpress::Paginator.builder.posts(posts).index(position).build
            Simpress::Generator::Html::PermalinkRenderer.generate(position, post, paginator)

            date = Time.new(post.date.year, post.date.month, 1)
            (monthly_archives[date] ||= []) << post
            archives << post
          end

          paginator = Simpress::Paginator.builder.maxpage(page_size).page(page + 1).build
          Simpress::Generator::Html::IndexRenderer.generate_index(archives, paginator)
        end

        Simpress::Generator::Html::PageRenderer.generate(pages)
        Simpress::Generator::Html::CategoryIndexRenderer.generate(category_posts)
        Simpress::Generator::Html::MonthlyIndexRenderer.generate(monthly_archives)
      end
    end
  end
end
