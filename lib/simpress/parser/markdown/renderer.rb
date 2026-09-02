# frozen_string_literal: true

require "cgi"
require "redcarpet"

require "simpress/parser/markdown/enhancer"

module Simpress
  module Parser
    module Markdown
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = { hard_wrap: true, escape_html: true }.freeze

        attr_reader :primary_image, :links

        def initialize(options = nil)
          super(options || RENDERER_OPTIONS)
          reset!
        end

        def reset!
          @primary_image = nil
          @headings      = []
          @links         = []
          @section_count = 0
        end

        def preprocess(markdown)
          Simpress::Parser::Markdown::Enhancer.run(markdown)
        end

        def link(url, _title, content)
          @links << url if url&.start_with?("/")
          %(<a href="#{url}" target="_blank" rel="noopener">#{content}</a>)
        end

        def autolink(url, _link_type)
          link(url, nil, url)
        end

        def header(text, header_level)
          tag = "h#{header_level}"
          return "<#{tag}>#{text}</#{tag}>" if header_level == 1

          id = "section-#{@section_count += 1}"
          @headings << { id: id, text: text, level: header_level }
          %(<#{tag} id="#{id}">#{text}</#{tag}>)
        end

        def toc
          state = @headings.each_with_object({ result: [], current_level: nil }) do |heading, s|
            if s[:current_level].nil? || heading[:level] <= s[:current_level]
              s[:result] << { id: heading[:id], text: heading[:text], children: [] }
              s[:current_level] = heading[:level]
            else
              s[:result].last[:children] << { id: heading[:id], text: heading[:text] }
            end
          end

          state[:result]
        end

        def image(path, _title, _alt)
          @primary_image ||= path
          %(<img src="#{path}" alt="image" />)
        end

        def block_code(code, lang)
          lang ||= "text"
          %(<pre class="line-numbers"><code class="language-#{lang}">#{CGI.escapeHTML(code)}</code></pre>)
        end

        # simplecov:disable
        def block_html(html)
          html
        end
        # simplecov:enable
      end
    end
  end
end
