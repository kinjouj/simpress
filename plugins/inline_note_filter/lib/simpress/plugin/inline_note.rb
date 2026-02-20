# frozen_string_literal: true

require "simpress/parser/markdown/enhancer"

module Simpress
  module Plugin
    class InlineNote
      extend Simpress::Parser::Markdown::Enhancer

      INLINE_NOTE_REGEX = /^\[\^\]:\s*([^\r\n]+)$/

      def self.preprocess(markdown)
        markdown.gsub(INLINE_NOTE_REGEX, %(<div class="note"><i class="fa-solid fa-circle-exclamation"></i>\\1</div>))
      end
    end
  end
end
