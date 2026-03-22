# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"

module Simpress
  module Generator
    module Renderer
      class IndexRenderer < BaseRenderer
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :categories, :cover, :description].freeze

        class << self
          def generate_html(posts, paginator)
            context = build_context(posts: posts, paginator: paginator)
            write_html(paginator.current_page, template: "index", context: context) do |file_path|
              logger_info("create archive: #{file_path}")
            end
          end

          def generate_json(posts, paginator)
            write_json(uri("/archives/page").path(paginator.page), posts, keys: DATA_JSON_KEYS) do |file_path|
              logger_info("create archive: #{file_path}")
            end
          end
        end
      end
    end
  end
end
