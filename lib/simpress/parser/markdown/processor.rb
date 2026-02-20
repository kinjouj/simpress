# frozen_string_literal: true

require "redcarpet"
require "simpress/parser/markdown/renderer"

module Simpress
  module Parser
    module Markdown
      module Processor
        class << self
          REDCARPET_OPTIONS = {
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            autolink: true
          }.freeze

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
            body = super
            [body, renderer.primary_image, renderer.toc]
          end
        end

        private_constant :Markdown
      end
    end
  end
end
