# frozen_string_literal: true

require "pathname"
require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class PageRenderer
        class << self
          def generate_html(pages)
            pages.each do |page|
              file_path = File.join("/page", page.rebase(".html"))
              data = Simpress::Theme.render("page", post: page)
              Simpress::Writer.write(file_path, data)
              Simpress::Logger.info("create page: #{file_path}")
            end
          end

          def generate_json(pages)
            pages.each do |page|
              file_path = File.join("/page", page.rebase(".json"))
              Simpress::Writer.write(file_path, page.to_json(include_content: true))
              Simpress::Logger.info("create page: #{file_path}")
            end
          end
        end
      end
    end
  end
end
