# frozen_string_literal: true

require "simpress/paginator"
require "simpress/generator/renderer/index_renderer"
require "simpress/generator/renderer/permalink_renderer"
require "simpress/generator/renderer/page_renderer"
require "simpress/generator/renderer/category_index_renderer"
require "simpress/generator/renderer/monthly_index_renderer"

module Simpress
  module Generator
    module Html
      def self.generate(posts, pages, _)
        paginate          = Simpress::Paginator.paginate
        page_size         = Simpress::Paginator.calculate_pagesize(posts)
        post_paginator    = Simpress::Paginator.builder.posts(posts)
        index_paginator   = Simpress::Paginator.builder.maxpage(page_size)
        monthly_archives  = Hash.new {|h, k| h[k] = [] }
        category_posts    = Hash.new {|h, k| h[k] = [] }
        posts.each_slice(paginate).each.with_index do |slice_posts, page|
          archives = []
          slice_posts.each.with_index do |post, index|
            post.categories.each {|category| category_posts[category] << post }
            position = (page * paginate) + index
            Simpress::Generator::Renderer::PermalinkRenderer.generate_html(post, post_paginator.index(position).build)

            date = Time.new(post.date.year, post.date.month, 1)
            monthly_archives[date] << post
            archives << post
          end

          Simpress::Generator::Renderer::IndexRenderer.generate_index(archives, index_paginator.page(page + 1).build)
        end

        Simpress::Generator::Renderer::PageRenderer.generate_html(pages)
        Simpress::Generator::Renderer::CategoryIndexRenderer.generate_html(category_posts)
        Simpress::Generator::Renderer::MonthlyIndexRenderer.generate_html(monthly_archives)
      end
    end
  end
end
