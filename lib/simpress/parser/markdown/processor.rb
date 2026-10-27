# frozen_string_literal: true

require "redcarpet"
require "simpress/parser/markdown/renderer"

module Simpress
  module Parser
    module Markdown
      module Processor
        REDCARPET_OPTIONS = {
          autolink: true,
          fenced_code_blocks: true,
          no_intra_emphasis: true,
          tables: true
        }.freeze

        class << self
          def render(data)
            renderer = Simpress::Parser::Markdown::Renderer.new
            content = ::Redcarpet::Markdown.new(renderer, REDCARPET_OPTIONS).render(data)
            Result.new(content, renderer.primary_image, renderer.toc)
          end
        end

        class Result
          attr_reader :content, :cover, :toc

          def initialize(content, cover, toc)
            @content = content
            @cover = cover
            @toc = toc
          end
        end
      end
    end
  end
end
