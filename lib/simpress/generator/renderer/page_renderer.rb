# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"

module Simpress
  module Generator
    module Renderer
      class PageRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :content].freeze

        class << self
          def generate_html(pages)
            pages.each do |page|
              context = build_context(post: page)
              write_html(uri("/page").path(page.permalink), template: "page", context: context) do |file_path|
                logger_info("create page: #{file_path}}")
              end
            end
          end

          def generate_json(pages)
            pages.each do |page|
              write_json(uri("/page").path(page.permalink), page, keys: DATA_JSON_KEYS) do |file_path|
                logger_info("create page: #{file_path}")
              end
            end
          end
        end
      end
    end
  end
end
