# frozen_string_literal: true

require "pathname"
require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class PermalinkRenderer
        def self.generate_html(post, paginator = nil)
          data = Simpress::Theme.render("post", post: post, paginator: paginator)
          Simpress::Writer.write(post.permalink, data) do |file_path|
            FileUtils.touch(file_path, mtime: post.date)
            Simpress::Logger.info(post.to_s)
          end
        end

        def self.generate_json(post)
          file_path = Pathname(post.permalink).sub_ext(".json").to_s
          Simpress::Writer.write(file_path, post.to_json(include_content: true)) do
            Simpress::Logger.info("create post #{file_path}")
          end
        end
      end
    end
  end
end
