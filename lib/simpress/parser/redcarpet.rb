# frozen_string_literal: true

require "redcarpet"
require "simpress/parser/redcarpet/renderer"

module Simpress
  module Parser
    module Redcarpet
      class Markdown < ::Redcarpet::Markdown
        def render(data)
          renderer.reset!
          body = super
          [body, renderer.primary_image, renderer.toc]
        end
      end

      REDCARPET_OPTIONS = {
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        highlight: true,
        autolink: true
      }.freeze

      PARSER = Markdown.new(Simpress::Parser::Redcarpet::Renderer.new, REDCARPET_OPTIONS)

      def self.render(data)
        PARSER.render(data)
      end

      private_constant :Markdown
    end
  end
end
