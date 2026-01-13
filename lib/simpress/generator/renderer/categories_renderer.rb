# frozen_string_literal: true

require "json"
require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class CategoriesRenderer
        def self.generate_json(categories)
          Simpress::Writer.write("/categories.json", categories.to_json) do |_|
            Simpress::Logger.info("create file: /categories.json")
          end
        end
      end
    end
  end
end
