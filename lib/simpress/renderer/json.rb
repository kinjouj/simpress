# frozen_string_literal: true

# :nocov:
module Simpress
  module Renderer
    module Json
      class << self
        def generate(posts, _, categories)
          FileUtils.mkdir_p("public/archives/page")
          FileUtils.mkdir_p("public/archives/category")
          category_posts = {}
          sliced_posts = posts.each_slice(10).to_a
          sliced_posts.each.with_index(1) do |sliced_post, page|
            archives = []
            sliced_post.each do |post|
              dirname  = File.dirname(post.permalink)
              basename = File.basename(post.permalink, ".*")
              filename = File.join(dirname, "#{basename}.json")
              post_categories = []
              post.categories.each do |category|
                post_categories << categories[category.to_url]
                category_posts[category.name] ||= []
                category_posts[category.name] << post
              end

              post.categories = post_categories.compact
              FileUtils.mkdir_p(File.join("public", dirname))
              File.write(File.join("public", filename), post.to_json)
              Simpress::Logger.info("create page #{filename}")
              archive = {
                title: post.title,
                cover: post.cover,
                path: filename
              }
              archives << archive
            end

            File.write("public/archives/page/#{page}.json", archives.to_json)
          end

          generate_category_posts(category_posts)
          generate_categories(categories)
          generate_pageinfo(sliced_posts.size)
        end

        private

        def generate_category_posts(categories)
          categories.each do |category, posts|
            File.write("public/archives/category/#{category.to_url}.json", posts.to_json)
          end
        end

        def generate_categories(categories)
          File.write("public/categories.json", categories.to_json)
        end

        def generate_pageinfo(pagesize)
          File.write("public/pageinfo.json", { page: pagesize }.to_json)
        end
      end
    end
  end
end
