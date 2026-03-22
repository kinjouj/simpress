# frozen_string_literal: true

require "cgi"
require "redcarpet"
require "simpress/parser/markdown/enhancer"

module Simpress
  module Parser
    module Markdown
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = { hard_wrap: true, escape_html: true }.freeze
        attr_reader :primary_image, :toc

        def initialize(options = nil)
          super(options || RENDERER_OPTIONS)
          reset!
        end

        def reset!
          @primary_image = nil
          @toc = []
        end

        def preprocess(markdown)
          Simpress::Parser::Markdown::Enhancer.run(markdown)
        end

        def header(text, header_level)
          return "<h#{header_level}>#{text}</h#{header_level}>" unless header_level == 3

          pos = @toc.size + 1
          id  = "section-#{pos}"
          @toc << [id, text]

          %(<h3 id="#{id}">#{text}</h3>)
        end

        def image(path, _title, _alt)
          @primary_image ||= path
          %(<img src="#{path}" alt="image" />)
        end

        def block_code(code, lang)
          lang ||= "text"
          %(<pre class="line-numbers"><code class="language-#{lang}">#{CGI.escapeHTML(code)}</code></pre>)
        end

        # :nocov:
        def block_html(html)
          html
        end
        # :nocov:
      end
    end
  end
end
