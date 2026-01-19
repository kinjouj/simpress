# frozen_string_literal: true

require "psych"

module Simpress
  module Markdown
    PERMITTED_CLASSES = [Time].freeze
    FRONT_MATTER_MARKDOWN_REGEX = /\A---\s*\n(?<header>(?:.*\n)*?)---\s*\n/

    def self.parse(txt, options = { symbolize_names: true, permitted_classes: PERMITTED_CLASSES })
      match = txt.match(FRONT_MATTER_MARKDOWN_REGEX)
      raise "Markdown parse failed" unless match

      header = Psych.safe_load(match[:header], **options)
      body   = match.post_match
      [header, body]
    end
  end
end
