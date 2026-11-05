# frozen_string_literal: true

require "psych"

module Simpress
  module Parser
    module Markdown
      FRONT_MATTER_MARKDOWN_REGEX = /\A---[^\S\n]*\n(?<header>(?:.*\n)*?)---[^\S\n]*\n/
      PERMITTED_CLASSES = [Date, Time].freeze

      def self.parse(file)
        match = File.read(file).match(FRONT_MATTER_MARKDOWN_REGEX)
        raise "Markdown parse failed: #{file}" unless match

        header = Psych.load(match[:header], filename: file, symbolize_names: true, permitted_classes: PERMITTED_CLASSES)
        raise "Front matter must be a mapping: #{file}" unless header.is_a?(Hash)

        body = match.post_match
        [header, body]
      end
    end
  end
end
