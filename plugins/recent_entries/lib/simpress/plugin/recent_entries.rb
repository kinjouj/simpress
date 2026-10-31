# frozen_string_literal: true

require "simpress/json"
require "simpress/plugin"
require "simpress/writer"

module Simpress
  module Plugin
    class RecentEntries
      extend Simpress::Plugin

      KEYS = [:id, :title, :permalink].freeze
      LIMIT = 5

      def self.run(entries)
        recent_entries = entries.select(&:index).take(LIMIT)

        case config.mode
        when "html"
          bind_context(recent_entries: recent_entries)
        when "json"
          Simpress::Writer.write("recent_entries.json", Simpress::JSON.dump(recent_entries, keys: KEYS))
        else
          raise "Unknown mode: #{config.mode}"
        end
      end
    end
  end
end
