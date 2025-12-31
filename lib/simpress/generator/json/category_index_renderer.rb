# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Json
      module CategoryIndexRenderer
        def self.generate(category_posts)
          category_posts.each do |category, posts|
            posts.sort_by! { |v| -v.date.to_time.to_i }
            filename = "/archives/category/#{category}.json"
            Simpress::Writer.write(filename, posts.to_json(include_content: true))
            Simpress::Logger.info("create category: #{filename}")
          end
        end
      end
    end
  end
end
