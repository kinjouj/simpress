# frozen_string_literal: true

require "oj"
require "simpress/logger"
require "simpress/paginator"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class IndexRenderer
        class << self
          def generate_html(posts, paginator, key = nil)
            posts.each_slice(Simpress::Paginator.paginate).each.with_index(1) do |slice_posts, page|
              paginator.page = page
              generate_index(slice_posts, paginator, key)
            end
          end

          def generate_index(posts, paginator, key = nil)
            data = Simpress::Theme.render("index", key: key, posts: posts, paginator: paginator)
            Simpress::Writer.write(paginator.current_page, data) do |_|
              Simpress::Logger.info("create index: #{paginator.current_page}")
            end
          end

          def generate_json(posts, page)
            file_path = File.join("/archives/page", "#{page}.json")
            Simpress::Writer.write(file_path, Oj.dump(posts, mode: :json)) do |_|
              Simpress::Logger.info("create archive: #{file_path}")
            end
          end
        end
      end
    end
  end
end
