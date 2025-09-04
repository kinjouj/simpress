# frozen_string_literal: true

module Simpress
  module Parser
    module Redcarpet
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = { hard_wrap: true, no_styles: true }.freeze
        attr_reader :primary_image, :toc

        def initialize(options = RENDERER_OPTIONS)
          super
          @primary_image = nil
          @toc = []
        end

        def preprocess(markdown)
          Simpress::Markdown::Filter.run(markdown)
        end

        def header(text, header_level)
          @toc << text if header_level == 4
          "<h4>#{text}</h4>"
        end

        def paragraph(text)
          "<p>#{text}</p>"
        end

        def autolink(link, _link_type = nil)
          %(<a href="#{link}" target="_blank" rel="noopener noreferrer">#{link}</a>)
        end

        def image(path, _title = nil, _alt = nil)
          @primary_image = path if @primary_image.blank?
          %(<img src="#{path}" alt="image" />)
        end

        def block_code(code, lang = "text")
          escape_code = code.gsub("&", "&amp;")
                            .gsub("\"", "&quot;")
                            .gsub("'", "&apos;")
                            .gsub("<", "&lt;")
                            .gsub(">", "&gt;")

          %(<pre class="line-numbers"><code class="language-#{lang}">#{escape_code}</code></pre>)
        end
      end
    end
  end
end
