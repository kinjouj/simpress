# frozen_string_literal: true

require "simpress/logger"
require "simpress/paginator"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Html
      module IndexRenderer
        def self.generate(posts, paginator, key = nil)
          posts.each_slice(Simpress::Paginator.paginate).each.with_index(1) do |slice_posts, page|
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
    end
  end
end
