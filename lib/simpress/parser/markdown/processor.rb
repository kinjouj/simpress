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

        Result = Data.define(:content, :toc, :links, :cover)

        class << self
          def render(data)
            parser.render(data)
          end

          private

          def parser
            @parser ||= Markdown.new(Simpress::Parser::Markdown::Renderer.new, REDCARPET_OPTIONS)
          end
        end

        class Markdown < ::Redcarpet::Markdown
          def render(data)
            renderer.reset!
            content = super
            Result.new(content: content, toc: renderer.toc, links: renderer.links, cover: renderer.primary_image)
          end
        end

        private_constant :Markdown
      end
    end
  end
end
