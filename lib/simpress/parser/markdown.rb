# frozen_string_literal: true

require "psych"

module Simpress
  module Parser
    module Markdown
      FRONT_MATTER_MARKDOWN_REGEX = /\A---[^\S\n]*\n(?<header>(?:.*\n)*?)---[^\S\n]*\n/
      PERMITTED_CLASSES = [Date, Time].freeze

      def self.parse(txt)
        match = txt.match(FRONT_MATTER_MARKDOWN_REGEX)
        raise "Markdown parse failed" unless match

        header = Psych.load(match[:header], symbolize_names: true, permitted_classes: PERMITTED_CLASSES, aliases: false)
        body   = match.post_match
        [header, body]
      end
    end
  end
end
