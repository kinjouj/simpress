# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Json
      module PermalinkRenderer
        def self.generate(post)
          filename = File.join(File.dirname(post.permalink), File.basename(post.permalink, ".*"))
          Simpress::Writer.write("#{filename}.json", post.to_json(include_content: true))
          Simpress::Logger.info("create page #{post.permalink}")
        end
      end
    end
  end
end
