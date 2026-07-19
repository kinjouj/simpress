# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      class PermalinkRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :toc, :adjacent].freeze

        def self.generate_html(post)
          write_html(post.permalink, template: post.layout, post: post) do |file_path|
            File.utime(post.date, post.date, file_path)
            Simpress::Logger.info("[BUILD PAGE]: #{post.title} #{file_path}")
          end
        end

        def self.generate_json(post)
          write_json(post.permalink, post, keys: DATA_JSON_KEYS) do |file_path|
            Simpress::Logger.info("[BUILD PAGE]: #{post.title} #{file_path}")
          end
        end
      end
    end
  end
end
