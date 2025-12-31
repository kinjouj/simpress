# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Json
      module PageInfoRenderer
        def self.generate(pagesize)
          Simpress::Writer.write("/pageinfo.json", { page: pagesize }.to_json)
          Simpress::Logger.info("create file: /pageinfo.json")
        end
      end
    end
  end
end
