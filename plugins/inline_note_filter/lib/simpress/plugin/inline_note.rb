# frozen_string_literal: true

require "simpress/parser/markdown/filter"

module Simpress
  module Plugin
    class InlineNote
      extend Simpress::Parser::Markdown::Filter

      INLINE_NOTE_REGEX = /^\[\^\]:[^\S\r\n]*([^\r\n]+)$/

      def self.preprocess(markdown)
        markdown.gsub(INLINE_NOTE_REGEX, %(<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>\\1</span></div>))
      end
    end
  end
end
