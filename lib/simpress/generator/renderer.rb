# frozen_string_literal: true

require "simpress/generator/renderer/page_renderer"
require "simpress/generator/renderer/permalink_renderer"
require "simpress/generator/renderer/archive/category_renderer"
require "simpress/generator/renderer/archive/monthly_renderer"
require "simpress/generator/renderer/archive/post_index_renderer"
require "simpress/paginator"

module Simpress
  module Generator
    module Renderer
      def self.generate(posts, pages, _categories)
        monthly_archives = Hash.new {|h, k| h[k] = [] }
        category_posts   = Hash.new {|h, k| h[k] = [] }
        [nil, *posts, nil].each_cons(3) do |newer_post, post, older_post|
          Simpress::Generator::Renderer::PermalinkRenderer.generate(post, older_post, newer_post)
          monthly_archives[Time.new(post.date.year, post.date.month, 1)] << post
          post.categories.each {|category| category_posts[category] << post }
        end

        Simpress::Generator::Renderer::PageRenderer.generate(pages)
        Simpress::Generator::Renderer::Archive::PostIndexRenderer.generate(posts)
        Simpress::Generator::Renderer::Archive::MonthlyRenderer.generate(monthly_archives)
        Simpress::Generator::Renderer::Archive::CategoryRenderer.generate(category_posts)
      end
    end
  end
end
