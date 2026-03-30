# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"
require "simpress/logger"

module Simpress
  module Generator
    module Renderer
      class PageRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :content].freeze

        class << self
          def generate_html(pages)
            base_path = uri("/page")
            pages.each do |page|
              write_html(base_path.path(page.permalink), template: "page", post: page) do |file_path|
                Simpress::Logger.info("create page: #{file_path}}")
              end
            end
          end

          def generate_json(pages)
            base_path = uri("/page")
            pages.each do |page|
              write_json(base_path.path(page.permalink), page, keys: DATA_JSON_KEYS) do |file_path|
                Simpress::Logger.info("create page: #{file_path}")
              end
            end
          end
        end
      end
    end
  end
end
