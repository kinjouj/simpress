# frozen_string_literal: true

require "psych"

module Simpress
  module Markdown
    PSYCH_OPTIONS = {
      symbolize_names: true,
      permitted_classes: [Time],
      aliases: false
    }.freeze
    FRONT_MATTER_MARKDOWN_REGEX = /\A---\s*\n(?<header>.*?)\n---\s*\n/m

    def self.parse(txt)
      match = txt.match(FRONT_MATTER_MARKDOWN_REGEX)
      raise "Markdown parse failed" unless match

      header = Psych.safe_load(match[:header], **PSYCH_OPTIONS)
      body   = match.post_match
      [header, body]
    end
  end
end
