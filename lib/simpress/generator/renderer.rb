# frozen_string_literal: true

require "simpress/generator/renderer/page"
require "simpress/generator/renderer/permalink"
require "simpress/generator/renderer/archive/monthly"
require "simpress/generator/renderer/archive/post_index"
require "simpress/generator/renderer/archive/taxonomy"
require "simpress/paginator"

module Simpress
  module Generator
    module Renderer
      def self.generate(posts, pages)
        monthly_archives = Hash.new {|h, k| h[k] = [] }
        [nil, *posts, nil].each_cons(3) do |newer_post, post, older_post|
          post.set_adjacent!(newer_post, older_post)
          Simpress::Generator::Renderer::Permalink.generate(post)
          monthly_archives[Time.new(post.date.year, post.date.month)] << post
        end

        Simpress::Generator::Renderer::Page.generate(pages)
        Simpress::Generator::Renderer::Archive::PostIndex.generate(posts)
        Simpress::Generator::Renderer::Archive::Monthly.generate(monthly_archives)
        Simpress::Generator::Renderer::Archive::Taxonomy.generate(Simpress::Taxonomy.taxonomies)
      end
    end
  end
end
