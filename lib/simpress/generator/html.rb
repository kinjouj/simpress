# frozen_string_literal: true

module Simpress
  module Generator
    module Html
      def self.generate(posts, pages, _)
        paginate          = Simpress::Paginator::Paging.paginate
        page_size         = Simpress::Paginator::Paging.calculate_pagesize(posts)
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
            PermalinkRenderer.generate(position, post, paginator)

            date = Time.new(post.date.year, post.date.month, 1)
            (monthly_archives[date] ||= []) << post
            archives << post
          end

          paginator = Simpress::Paginator.builder.maxpage(page_size).page(page + 1).build
          IndexRenderer.generate_index(archives, paginator)
        end

        PageRenderer.generate(pages)
        CategoryIndexRenderer.generate(category_posts)
        MonthlyIndexRenderer.generate(monthly_archives)
      end

      module PermalinkRenderer
        def self.generate(position, post, paginator = nil)
          result = Simpress::Theme.render("post", post: post, paginator: paginator)
          Simpress::Writer.write(post.permalink, result) {|filepath| FileUtils.touch(filepath, mtime: post.date.to_time) }
          Simpress::Logger.info("#{position + 1}: #{post}")
        end
      end

      module IndexRenderer
        def self.generate(posts, paginator, key = nil)
          posts.each_slice(Simpress::Paginator::Paging.paginate).each.with_index(1) do |slice_posts, page|
            paginator.page = page
            generate_index(slice_posts, paginator, key)
          end
        end

        def self.generate_index(posts, paginator, key = nil)
          result = Simpress::Theme.render("index", key: key, posts: posts, paginator: paginator)
          Simpress::Writer.write(paginator.current_page, result)
          Simpress::Logger.info("create index: #{paginator.current_page}")
        end
      end

      module CategoryIndexRenderer
        def self.generate(category_posts)
          category_posts.each do |category, posts|
            posts.sort_by! { |v| -v.date.to_time.to_i }
            paginator = Simpress::Paginator.builder
                                           .maxpage(Simpress::Paginator::Paging.calculate_pagesize(posts))
                                           .page(1)
                                           .prefix("/archives/category/#{category.key}")
                                           .build

            IndexRenderer.generate(posts, paginator, category.name)
          end
        end
      end

      module MonthlyIndexRenderer
        def self.generate(monthly_archives)
          monthly_archives.each do |date, posts_by_monthly|
            paginator = Simpress::Paginator.builder
                                           .maxpage(Simpress::Paginator::Paging.calculate_pagesize(posts_by_monthly))
                                           .page(1)
                                           .prefix("/archives/#{date.year}/#{format('%02d', date.month)}")
                                           .build

            IndexRenderer.generate(posts_by_monthly, paginator, "#{date.year}/#{date.month}")
          end
        end
      end

      module PageRenderer
        def self.generate(pages)
          pages.each_with_index do |page, index|
            generate_page(index, page)
            Simpress::Logger.info("create page: #{page.permalink}")
          end
        end

        def self.generate_page(index, page)
          result = Simpress::Theme.render("page", post: page)
          Simpress::Writer.write(page.permalink, result) {|filepath| FileUtils.touch(filepath, mtime: page.date.to_time) }
          Simpress::Logger.info("#{index + 1}: #{page}")
        end
      end
    end
  end
end
