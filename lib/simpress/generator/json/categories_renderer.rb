# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Json
      module CategoriesRenderer
        def self.generate(categories)
          Simpress::Writer.write("/categories.json", categories.to_json)
          Simpress::Logger.info("create file: /categories.json")
        end
      end
    end
  end
end
