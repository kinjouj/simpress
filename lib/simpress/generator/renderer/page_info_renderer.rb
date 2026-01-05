# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class PageInfoRenderer
        def self.generate_json(pagesize)
          Simpress::Writer.write("/pageinfo.json", { page: pagesize }.to_json) do |_|
            Simpress::Logger.info("create file: /pageinfo.json")
          end
        end
      end
    end
  end
end
