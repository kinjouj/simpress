# frozen_string_literal: true

require "delegate"
require "simpress/json"

module Simpress
  class Entry
    class Link < SimpleDelegator
      include Simpress::JSON::Serializable

      def self.build(entry)
        return nil if entry.nil?

        new(entry)
      end

      def to_h(_options = {})
        { id: id, title: title, permalink: permalink }
      end
    end
  end
end
