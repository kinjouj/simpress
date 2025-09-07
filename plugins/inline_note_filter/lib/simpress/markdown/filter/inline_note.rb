# frozen_string_literal: true

module Simpress
  module Markdown
    module Filter
      class InlineNote
        extend Simpress::Markdown::Filter

        def self.preprocess(markdown)
          markdown.gsub(
            /\[\^\]:\s?([^\n]+)\n/m,
            %(<div class="note"><span class="material-symbols-outlined">info</span>\\1</div>)
          )
        end
      end
    end
  end
end
