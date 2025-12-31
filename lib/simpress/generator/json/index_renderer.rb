# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Json
      module IndexRenderer
        def self.generate(posts, page)
          Simpress::Writer.write("/archives/page/#{page}.json", posts.to_json)
          Simpress::Logger.info("create archive: #{page}.json")
        end
      end
    end
  end
end
