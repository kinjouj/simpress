# frozen_string_literal: true

require "simpress/generator/pipeline/archive/base"
require "simpress/logger"

module Simpress
  module Generator
    module Pipeline
      module Archive
        class EntryIndex < Simpress::Generator::Pipeline::Archive::Base
          def self.generate_html(entries)
            each_page(entries) do |slice, paginator|
              write_html(paginator.current_page, template: "index", entries: slice, paginator: paginator) do |file|
                Simpress::Logger.verbose { "[BUILD ARCHIVE]: #{file}" }
              end
            end
          end

          def self.generate_json(entries)
            base_path = path("/archives/page")
            each_page(entries) do |slice, paginator|
              data = { entries: slice.map {|entry| entry.to_h(keys: DATA_JSON_KEYS) }, total_pages: paginator.maxpage }
              write_json(base_path.path(paginator.page), data) do |file|
                Simpress::Logger.verbose { "[BUILD ARCHIVE]: #{file}" }
              end
            end
          end
        end
      end
    end
  end
end
