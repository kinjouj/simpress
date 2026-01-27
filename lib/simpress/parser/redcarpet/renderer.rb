# frozen_string_literal: true

require "erb"
require "redcarpet"
require "xxhash"
require "simpress/markdown/filter"

module Simpress
  module Parser
    module Redcarpet
      class Renderer < ::Redcarpet::Render::HTML
        RENDERER_OPTIONS = { hard_wrap: true }.freeze
        attr_reader :primary_image, :toc

        def initialize(options = nil)
          super(options || RENDERER_OPTIONS)
          reset!
        end

        def reset!
          @primary_image = nil
          @toc ||= []
          @toc.clear
        end

        def preprocess(markdown)
          Simpress::Markdown::Filter.run(markdown)
        end

        def header(text, header_level)
          if header_level == 4
            pos = @toc.size + 1
            id  = XXhash.xxh64("toc-#{pos}-#{text}").to_s
            @toc << [id, text]

            %(<h#{header_level} id="#{id}">#{text}</h#{header_level}>)
          else
            "<h#{header_level}>#{text}</h#{header_level}>"
          end
        end

        def image(path, _title = nil, _alt = nil)
          @primary_image ||= path
          %(<img src="#{path}" alt="image" />)
        end

        def block_code(code, lang = "text")
          escape_code = ERB::Util.html_escape(code)
          %(<pre class="line-numbers"><code class="language-#{lang}">#{escape_code}</code></pre>)
        end
      end
    end
  end
end
