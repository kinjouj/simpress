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
              category_posts[category.name] ||= []
              category_posts[category.name] << post
            end

            position = (page * PAGINATE) + index
            Simpress::Renderer::Html::Post.build(post, Simpress::Paginator::Post.new(position, posts))
            date = Time.new(post.date.year, post.date.month, 1)
            monthly_archives[date] ||= []
            monthly_archives[date] << post
            archives << post
            Simpress::Logger.info("#{position + 1}: #{post.permalink}")
          end

          paginator = Simpress::Paginator::Index.new(page + 1, page_size)
          Simpress::Renderer::Html::Index.build(archives, paginator)
          Simpress::Logger.info("create index: #{paginator.current_page}")
        end

        pages.each do |page|
          Simpress::Renderer::Html::Page.build(page)
          Simpress::Logger.info("create page: #{page.permalink}")
        end

        category_posts.each do |category_name, posts|
          posts.sort_by! { |v| -v.date.to_time.to_i }
          maxpage   = posts.size.quo(PAGINATE).ceil
          paginator = Simpress::Paginator::Index.new(1, maxpage, "/archives/category/#{category_name.to_url}")
          generate_indexes(posts, paginator, category_name)
        end

        monthly_archives.each do |date, posts_by_monthly|
          maxpage   = posts_by_monthly.size.quo(PAGINATE).ceil
          paginator = Simpress::Paginator::Index.new(1, maxpage, "/archives/#{date.year}/#{format('%02d', date.month)}")
          generate_indexes(posts_by_monthly, paginator, "#{date.year}/#{date.month}")
        end
      end

      def self.generate_indexes(posts, paginator, key = nil)
        posts.each_slice(PAGINATE).each.with_index(1) do |slice_posts, page|
          paginator.page = page
          Simpress::Renderer::Html::Index.build(slice_posts, paginator, key)
          Simpress::Logger.info("create index: #{paginator.current_page}")
        end
      end
    end
  end
end
