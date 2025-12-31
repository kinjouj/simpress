# frozen_string_literal: true

require "simpress/logger"
require "simpress/theme"
require "simpress/writer"

module Simpress
  module Generator
    module Html
      module PageRenderer
        def self.generate(pages)
          pages.each do |page|
            result = Simpress::Theme.render("page", post: page)
            Simpress::Writer.write(page.permalink, result) {|filepath| FileUtils.touch(filepath, mtime: page.date.to_time) }
            Simpress::Logger.info("create page: #{page.permalink}")
          end
        end
      end
    end
  end
end
