# frozen_string_literal: true

require "redcarpet"
require "simpress/parser/redcarpet/renderer"

module Simpress
  module Parser
    module Redcarpet
      REDCARPET_OPTIONS = {
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        highlight: true,
        autolink: true,
        footnotes: true,
        tables: true,
        quote: true
      }.freeze

      def self.render(data)
        parser = Markdown.new(Simpress::Parser::Redcarpet::Renderer.new, REDCARPET_OPTIONS)
        parser.render(data)
      end

      class Markdown < ::Redcarpet::Markdown
        def render(data)
          body = super
          [ body, renderer.primary_image, renderer.toc ]
        end
      end

      private_constant :Markdown
    end
  end
end
