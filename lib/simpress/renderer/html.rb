# frozen_string_literal: true

module Simpress
  module Renderer
    module Html
      PAGINATE = Simpress::Config.instance.paginate || 10

      def self.generate(posts, pages, _)
        page_size         = posts.size.quo(PAGINATE).ceil
        monthly_archives  = {}
        category_posts    = {}
        posts.each_slice(PAGINATE).each.with_index do |slice_posts, page|
          archives = []
          slice_posts.each.with_index do |post, index|
            post.categories.each do |category|
              category_posts[category] ||= []
              category_posts[category] << post
            end

            position  = (page * PAGINATE) + index
            paginator = Simpress::Paginator.builder.page(position).posts(posts).build
            generate_permalink(post, "post", paginator)
            date = Time.new(post.date.year, post.date.month, 1)
            monthly_archives[date] ||= []
            monthly_archives[date] << post
            archives << post
            Simpress::Logger.info("#{position + 1}: #{post}")
          end

          paginator = Simpress::Paginator.builder
                                         .page(page + 1)
                                         .maxpage(page_size)
                                         .build
          generate_index(archives, paginator)
          Simpress::Logger.info("create index: #{paginator.current_page}")
        end

        pages.each do |page|
          generate_permalink(page, "page")
          Simpress::Logger.info("create page: #{page.permalink}")
        end

        category_posts.each do |category, posts|
          posts.sort_by! { |v| -v.date.to_time.to_i }
          maxpage   = posts.size.quo(PAGINATE).ceil
          paginator = Simpress::Paginator.builder
                                         .page(1)
                                         .maxpage(maxpage)
                                         .prefix("/archives/category/#{category.key}")
                                         .build
          generate_indexes(posts, paginator, category.name)
        end

        monthly_archives.each do |date, posts_by_monthly|
          maxpage   = posts_by_monthly.size.quo(PAGINATE).ceil
          paginator = Simpress::Paginator.builder
                                         .page(1)
                                         .maxpage(maxpage)
                                         .prefix("/archives/#{date.year}/#{format('%02d', date.month)}")
                                         .build
          generate_indexes(posts_by_monthly, paginator, "#{date.year}/#{date.month}")
        end
      end

      def self.generate_permalink(post, template, paginator = nil)
        result = Simpress::Theme.render(template, post: post, paginator: paginator)
        Simpress::Writer.write(post.permalink, result) {|filepath| FileUtils.touch(filepath, mtime: post.date.to_time) }
      end

      def self.generate_index(posts, paginator, key = nil)
        result = Simpress::Theme.render("index", key: key, posts: posts, paginator: paginator)
        Simpress::Writer.write(paginator.current_page, result)
      end

      def self.generate_indexes(posts, paginator, key = nil)
        posts.each_slice(PAGINATE).each.with_index(1) do |slice_posts, page|
          paginator.page = page
          generate_index(slice_posts, paginator, key)
          Simpress::Logger.info("create index: #{paginator.current_page}")
        end
      end
    end
  end
end
