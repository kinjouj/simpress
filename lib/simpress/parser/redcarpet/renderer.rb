# frozen_string_literal: true

require "erb"
require "only_blank"
require "redcarpet"
require "simpress/markdown/filter"

module Simpress
  module Parser
    module Redcarpet
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = { hard_wrap: true, no_styles: true }.freeze
        attr_reader :primary_image, :toc

        def initialize(options = nil)
          super(options || RENDERER_OPTIONS)
          @primary_image = nil
          @toc = []
        end

        def preprocess(markdown)
          Simpress::Markdown::Filter.run(markdown)
        end

        def header(text, header_level)
          @toc << text if header_level == 4
          "<h#{header_level}>#{text}</h#{header_level}>"
        end

        def paragraph(text)
          "<p>#{text}</p>"
        end

        def autolink(link, _link_type = nil)
          %(<a href="#{link}" target="_blank" rel="noopener noreferrer">#{link}</a>)
        end

        def image(path, _title = nil, _alt = nil)
          @primary_image = path if @primary_image.blank?
          %(<img src="#{path}" class="img-fluid" alt="image" />)
        end

        def block_code(code, lang = "text")
          escape_code = ERB::Util.html_escape(code)
          %(<pre class="line-numbers"><code class="language-#{lang}">#{escape_code}</code></pre>)
        end
      end
    end
  end
end
