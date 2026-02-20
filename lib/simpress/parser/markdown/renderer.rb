# frozen_string_literal: true

require "cgi"
require "redcarpet"
require "xxhash"
require "simpress/parser/markdown/enhancer"

module Simpress
  module Parser
    module Markdown
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = { hard_wrap: true }.freeze
        attr_reader :primary_image, :toc

        @klasses = []

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
          if header_level == 4
            pos = @toc.size + 1
            id  = "section-#{pos}"
            @toc << [id, text]

            %(<h4 id="#{id}">#{text}</h4>)
          else
            "<h#{header_level}>#{text}</h#{header_level}>"
          end
        end

        def image(path, _title, _alt)
          @primary_image ||= path
          %(<img src="#{path}" alt="image" />)
        end

        def block_code(code, lang = "text")
          escape_code = CGI.escapeHTML(code)
          %(<pre class="line-numbers"><code class="language-#{lang}">#{escape_code}</code></pre>)
        end
      end
    end
  end
end
