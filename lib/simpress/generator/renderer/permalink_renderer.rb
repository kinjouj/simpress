# frozen_string_literal: true

require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class PermalinkRenderer
        def self.generate_html(post, paginator = nil)
          data = Simpress::Theme.render("post", post: post, paginator: paginator)
          Simpress::Writer.write(post.rebase(".html"), data) do |file_path|
            FileUtils.touch(file_path, mtime: post.date)
            Simpress::Logger.info(post.to_s)
          end
        end

        def self.generate_json(post)
          file_path = post.rebase(".json")
          Simpress::Writer.write(file_path, post.to_json(include_content: true))
          Simpress::Logger.info("create post #{file_path}")
        end
      end
    end
  end
end
