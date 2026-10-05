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
            Markdown.new(Simpress::Parser::Markdown::Renderer.new, REDCARPET_OPTIONS).render(data)
          end
        end

        class Markdown < ::Redcarpet::Markdown
          def render(data)
            content = super
            Result.new(content: content, toc: renderer.toc, cover: renderer.primary_image)
          end
        end

        private_constant :Markdown
      end
    end
  end
end
