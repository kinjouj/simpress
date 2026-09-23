# frozen_string_literal: true

require "simpress/generator/pipeline/permalink"
require "simpress/generator/pipeline/archive/monthly"
require "simpress/generator/pipeline/archive/post_index"
require "simpress/generator/pipeline/archive/taxonomy"
require "simpress/paginator"

module Simpress
  module Generator
    module Pipeline
      def self.generate(posts)
        monthly_archives = Hash.new {|h, k| h[k] = [] }
        index_posts = []
        posts.each do |post|
          Simpress::Generator::Pipeline::Permalink.generate(post)
          next unless post.index

          index_posts << post
          monthly_archives[Time.new(post.date.year, post.date.month)] << post
        end

        Simpress::Generator::Pipeline::Archive::PostIndex.generate(index_posts)
        Simpress::Generator::Pipeline::Archive::Monthly.generate(monthly_archives)
        Simpress::Generator::Pipeline::Archive::Taxonomy.generate(Simpress::Taxonomy.taxonomies)
      end
    end
  end
end
