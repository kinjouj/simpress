# frozen_string_literal: true

# :nocov:
module Simpress
  module Renderer
    module Json
      OUTPUT_DIR = Simpress::Config.instance.output_dir || "public"

      class << self
        def generate(posts, _, categories)
          category_posts = {}
          monthly_posts  = {}
          sliced_posts = posts.each_slice(10).to_a
          sliced_posts.each.with_index(1) do |sliced_post, page|
            archives = []
            sliced_post.each do |post|
              basename = File.basename(post.permalink, ".*")
              filename = File.join(File.dirname(post.permalink), "#{basename}.json")
              post.categories = post.categories.map do |category|
                category_posts[category.name] ||= []
                category_posts[category.name] << post
                categories[category.to_url]
              end

              Simpress::Writer.write(filename, post.to_json)
              Simpress::Logger.info("create page #{filename}")
              archive = {
                title: post.title,
                cover: post.cover,
                path: filename
              }
              date = Time.new(post.date.year, post.date.month, 1)
              monthly_posts[date] ||= []
              monthly_posts[date] << post
              archives << archive
            end

            Simpress::Writer.write("/archives/page/#{page}.json", archives.to_json)
          end

          generate_category_posts(category_posts)
          generate_monthly_posts(monthly_posts)
          generate_categories(categories)
          generate_pageinfo(sliced_posts.size)
        end

        private

        def generate_category_posts(categories)
          categories.each do |category, posts|
            Simpress::Writer.write("/archives/category/#{category.to_url}.json", posts.to_json)
          end
        end

        def generate_monthly_posts(monthly_posts)
          monthly_posts.each do |date, posts|
            filename = date.strftime("%Y/%02m.json")
            Simpress::Writer.write("/archives/#{filename}", posts.to_json)
          end
        end

        def generate_categories(categories)
          Simpress::Writer.write("/categories.json", categories.to_json)
        end

        def generate_pageinfo(pagesize)
          Simpress::Writer.write("/pageinfo.json", { page: pagesize }.to_json)
        end
      end
    end
  end
end
