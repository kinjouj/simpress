# frozen_string_literal: true

require "redcarpet"
require "simpress/parser/redcarpet/renderer"

module Simpress
  module Parser
    module Redcarpet
      class << self
        REDCARPET_OPTIONS = {
          no_intra_emphasis: true,
          fenced_code_blocks: true,
          autolink: true,
          highlight: true
        }.freeze

        def render(data)
          parser.render(data)
        end

        private

        def parser
          @parser ||= Markdown.new(Simpress::Parser::Redcarpet::Renderer.new, REDCARPET_OPTIONS)
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
