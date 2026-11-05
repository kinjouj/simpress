# frozen_string_literal: true

require "cgi"
require "simpress/parser/markdown/filter"

module Simpress
  module Parser
    module Markdown
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = {
          hard_wrap: true
        }.freeze

        attr_reader :primary_image

        def initialize(options = nil)
          super(options || RENDERER_OPTIONS)
          @primary_image = nil
          @headings = []
        end

        def preprocess(markdown)
          Simpress::Parser::Markdown::Filter.apply_preprocess(markdown)
        end

        def postprocess(document)
          Simpress::Parser::Markdown::Filter.apply_postprocess(document)
        end

        def header(text, header_level)
          tag = "h#{header_level}"
          return "<#{tag}>#{text}</#{tag}>" if header_level == 1

          id = "section-#{@headings.size + 1}"
          @headings << { id: id, text: text, level: header_level }
          %(<#{tag} id="#{id}">#{text}</#{tag}>)
        end

        def block_code(code, lang)
          lang ||= "text"
          %(<pre class="line-numbers"><code class="language-#{lang}">#{CGI.escapeHTML(code)}</code></pre>)
        end

        def image(path, title, alt)
          @primary_image ||= path
          %(<img src="#{path}" alt="#{alt}" title="#{title}" />)
        end

        def toc
          current_level = nil
          @headings.each_with_object([]) do |heading, result|
            if current_level.nil? || heading[:level] <= current_level
              result << { id: heading[:id], text: heading[:text], children: [] }
              current_level = heading[:level]
            else
              result.last[:children] << { id: heading[:id], text: heading[:text] }
            end
          end
        end
      end
    end
  end
end
