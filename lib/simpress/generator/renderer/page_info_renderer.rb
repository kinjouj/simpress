# frozen_string_literal: true

require "oj"
require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Renderer
      class PageInfoRenderer
        def self.generate_json(pagesize)
          Simpress::Writer.write("/pageinfo.json", Oj.dump({ page: pagesize }, mode: :json)) do |_|
            Simpress::Logger.info("create file: /pageinfo.json")
          end
        end
      end
    end
  end
end
