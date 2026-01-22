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
              file_path = File.join("/page", Pathname.new(page.permalink).sub_ext(".html").to_s)
              data = Simpress::Theme.render("page", post: page)
              Simpress::Writer.write(file_path, data) do |_|
                Simpress::Logger.info("create page: #{file_path}")
              end
            end
          end

          def generate_json(pages)
            pages.each do |page|
              file_path = File.join("/page", Pathname.new(page.permalink).sub_ext(".json").to_s)
              Simpress::Writer.write(file_path, page.to_json(include_content: true)) do |_|
                Simpress::Logger.info("create page: #{file_path}")
              end
            end
          end
        end
      end
    end
  end
end
