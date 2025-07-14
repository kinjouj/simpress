# frozen_string_literal: true

module Simpress
  class Markdown
    PERMITTED_CLASSES = [ Date, Time, Symbol ].freeze

    def self.parse(txt, options = { symbolize_names: true, permitted_classes: PERMITTED_CLASSES })
      match = txt.match(/\A(?<header>---\s*\n.*?\n?)^(---\s*$\n?)/m)
      raise "PARSE ERROR" unless match

      header = Psych.safe_load(match[:header], **options)
      body = match.post_match
      [ header, body ]
    end
  end
end
