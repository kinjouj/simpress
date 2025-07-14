# frozen_string_literal: true

# :nocov:
module Simpress
  module Renderer
    module Json
      def self.generate(data)
        # posts, pages, categories = data
        posts, _, categories = data
        category_posts = {}
        sliced_posts = posts.each_slice(10).to_a
        sliced_posts.each.with_index(1) do |sliced_post, page|
          archives = []
          sliced_post.each do |post|
            post_categories = []
            post.categories.each do |category|
              post_categories << categories[category.to_url]
              category_posts[category.name] ||= []
              category_posts[category.name] << post
            end

            post.categories = post_categories

            dirname   = File.dirname(post.permalink)
            basename  = File.basename(post.permalink, ".html")
            FileUtils.mkdir_p("public/#{dirname}")
            File.write("public/#{dirname}/#{basename}.json", post.to_json)
            Simpress::Logger.info("create page #{dirname}/#{basename}.json")
            archives << post
          end

          File.write("public/page#{page}.json", archives.to_json)
        end

        File.write("public/categort_posts.json", category_posts.to_json)
        File.write("public/categories.json", categories.to_json)
        File.write("public/pageinfo.json", { page: sliced_posts.size }.to_json)
      end
    end
  end
end
