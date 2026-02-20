# frozen_string_literal: true

require "psych"

module Simpress
  module Parser
    module Markdown
      FRONT_MATTER_MARKDOWN_REGEX = /\A---\s*\n(?<header>.*?)\n---\s*\n/m

      def self.parse(txt)
        match = txt.match(FRONT_MATTER_MARKDOWN_REGEX)
        raise "Markdown parse failed" unless match

        header = Psych.load(match[:header], symbolize_names: true, permitted_classes: [Time], aliases: false)
        body   = match.post_match
        [header, body]
      end
    end
  end
end
