# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      class PermalinkRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :content, :toc].freeze
        Paginator      = Data.define(:newer_post, :older_post)

        def self.generate_html(post, older_post = nil, newer_post = nil)
          paginator = Paginator.new(newer_post: newer_post, older_post: older_post)
          write_html(post.permalink, template: "page", post: post, paginator: paginator) do |file_path|
            File.utime(post.date, post.date, file_path)
            Simpress::Logger.info(post.to_s)
          end
        end

        def self.generate_json(post, *)
          write_json(post.permalink, post, keys: DATA_JSON_KEYS) { Simpress::Logger.info(post.to_s) }
        end
      end
    end
  end
end
