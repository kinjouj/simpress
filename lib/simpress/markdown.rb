# frozen_string_literal: true

module Simpress
  module Markdown
    class MarkdownError < StandardError; end

    PERMITTED_CLASSES = [ Date, Time, Symbol ].freeze

    def self.parse(txt)
      match = txt.match(/\A(?<header>---\s*\n.*?\n?)^(---\s*$\n?)/m)
      raise MarkdownError, "Markdown parse failed" unless match

      params = Psych.safe_load(match[:header], symbolize_names: true, permitted_classes: PERMITTED_CLASSES) || {}
      body   = match.post_match
      [ params, body ]
    end
  end
end
