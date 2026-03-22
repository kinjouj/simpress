# frozen_string_literal: true

require "simpress/generator/renderer/category_index_renderer"
require "simpress/generator/renderer/index_renderer"
require "simpress/generator/renderer/monthly_index_renderer"
require "simpress/generator/renderer/page_renderer"
require "simpress/generator/renderer/permalink_renderer"
require "simpress/paginator"

module Simpress
  module Generator
    module Renderer
      def self.generate(posts, pages, _)
        monthly_archives = Hash.new {|h, k| h[k] = [] }
        category_posts   = Hash.new {|h, k| h[k] = [] }
        [nil, *posts, nil].each_cons(3) do |newer_post, post, older_post|
          Simpress::Generator::Renderer::PermalinkRenderer.generate(post, older_post, newer_post)
          monthly_archives[Time.new(post.date.year, post.date.month, 1)] << post
          post.categories.each {|category| category_posts[category] << post }
        end

        Simpress::Paginator.each_page(posts) do |slice_posts, paginator|
          Simpress::Generator::Renderer::IndexRenderer.generate(slice_posts, paginator)
        end

        Simpress::Generator::Renderer::PageRenderer.generate(pages)
        Simpress::Generator::Renderer::CategoryIndexRenderer.generate(category_posts)
        Simpress::Generator::Renderer::MonthlyIndexRenderer.generate(monthly_archives)
      end
    end
  end
end
