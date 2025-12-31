# frozen_string_literal: true

require "simpress/markdown/filter"

module Simpress
  module Markdown
    module Filter
      class InlineNote
        extend Simpress::Markdown::Filter

        def self.preprocess(markdown)
          markdown.gsub(
            /\[\^\]:\s?([^\n]+)\n/m,
            %(<div class="note"><i class="fa-solid fa-circle-exclamation"></i>\\1</div>)
          )
        end
      end
    end
  end
end
