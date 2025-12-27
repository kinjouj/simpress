# frozen_string_literal: true

module Simpress
  module Markdown
    class MarkdownError < StandardError; end

    @parser = FrontMatterParser::Parser.new(
      :md,
      loader: FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Time])
    )

    def self.parse(txt)
      data   = @parser.call(txt)
      params = (data.front_matter || {}).transform_keys(&:to_sym)
      body   = data.content || ""

      raise MarkdownError, "Markdown parse failed" if params.empty? || body.strip.empty?

      [ params, body, body.to_s.split(/\n{2,}/).first.to_s.strip ]
    end
  end
end
