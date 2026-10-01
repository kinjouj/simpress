# frozen_string_literal: true

require "simpress/generator/pipeline/base"
require "simpress/logger"

module Simpress
  module Generator
    module Pipeline
      class Permalink < Simpress::Generator::Pipeline::Base
        DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :content, :toc, :next, :prev].freeze

        def self.generate_html(entry)
          write_html(entry.permalink, template: entry.layout, entry: entry) do |file|
            File.utime(entry.date, entry.date, file)
            Simpress::Logger.verbose("[BUILD PAGE]: #{entry.title} #{file}")
          end
        end

        def self.generate_json(entry)
          write_json(entry.permalink, entry, keys: DATA_JSON_KEYS) do |file|
            Simpress::Logger.verbose("[BUILD PAGE]: #{entry.title} #{file}")
          end
        end
      end
    end
  end
end
