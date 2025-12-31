# frozen_string_literal: true

require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Html
      class PermalinkRenderer
        def self.generate(position, post, paginator = nil)
          result = Simpress::Theme.render("post", post: post, paginator: paginator)
          Simpress::Writer.write(post.permalink, result) {|filepath| FileUtils.touch(filepath, mtime: post.date.to_time) }
          Simpress::Logger.info("#{position + 1}: #{post}")
        end
      end
    end
  end
end
