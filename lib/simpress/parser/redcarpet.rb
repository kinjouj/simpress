# frozen_string_literal: true

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
        parser = Simpress::Parser::Redcarpet::Markdown.new(Simpress::Parser::Redcarpet::Renderer.new, REDCARPET_OPTIONS)
        parser.render(data)
      end
    end
  end
end
