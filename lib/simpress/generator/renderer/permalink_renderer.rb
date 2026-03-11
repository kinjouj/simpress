# frozen_string_literal: true

require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class PermalinkRenderer
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :content, :toc].freeze

        def self.generate_html(post, paginator = nil)
          file = post.permalink(".html")
          data = Simpress::Theme.render("post", post: post, paginator: paginator)
          Simpress::Writer.write(file, data) do |file_path|
            File.utime(post.date, post.date, file_path)
            Simpress::Logger.info(post.to_s)
          end
        end

        def self.generate_json(post)
          file = post.permalink(".json")
          Simpress::Writer.write(file, post.to_json(keys: DATA_JSON_KEYS)) do |file_path|
            Simpress::Logger.info("create post #{file_path}")
          end
        end
      end
    end
  end
end
