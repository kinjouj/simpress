# frozen_string_literal: true

require "simpress/generator/pipeline/base"
require "simpress/logger"

module Simpress
  module Generator
    module Pipeline
      class Page < Simpress::Generator::Pipeline::Base
        DATA_JSON_KEYS = [:id, :title, :content].freeze

        class << self
          def generate_html(pages)
            base_path = path("/page")
            pages.each do |page|
              write_html(base_path.path(page.permalink), template: page.layout, post: page) do |file|
                Simpress::Logger.verbose("[BUILD PAGE]: #{page.title} #{file}")
              end
            end
          end

          def generate_json(pages)
            base_path = path("/page")
            pages.each do |page|
              write_json(base_path.path(page.permalink), page, keys: DATA_JSON_KEYS) do |file|
                Simpress::Logger.verbose("[BUILD PAGE]: #{page.title} #{file}")
              end
            end
          end
        end
      end
    end
  end
end
