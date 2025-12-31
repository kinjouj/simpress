# frozen_string_literal: true

require "simpress/logger"
require "simpress/writer"

module Simpress
  module Generator
    module Json
      module MonthlyIndexRenderer
        def self.generate(monthly_posts)
          monthly_posts.each do |date, posts|
            year_month = date.strftime("%Y/%02m")
            filename = "/archives/#{year_month}.json"
            Simpress::Writer.write(filename, posts.to_json)
            Simpress::Logger.info("create archive: #{filename}")
          end
        end
      end
    end
  end
end
