# frozen_string_literal: true

require "redcarpet"
require "simpress/parser/markdown/renderer"

module Simpress
  module Parser
    module Markdown
      module Processor
        REDCARPET_OPTIONS = {
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          autolink: true
        }.freeze

        Result = Data.define(:content, :toc, :cover)

        class << self
          def render(data)
            renderer = Simpress::Parser::Markdown::Renderer.new
            content = ::Redcarpet::Markdown.new(renderer, REDCARPET_OPTIONS).render(data)
            Result.new(content: content, toc: renderer.toc, cover: renderer.primary_image)
          end
        end
      end
    end
  end
end
