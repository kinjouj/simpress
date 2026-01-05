# frozen_string_literal: true

require "front_matter_parser"

module Simpress
  module Markdown
    class MarkdownError < StandardError; end

    PARSER = FrontMatterParser::Parser.new(
      :md,
      loader: FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Time])
    )

    def self.parse(txt)
      data   = PARSER.call(txt)
      body   = data.content || ""
      params = {}
      (data.front_matter || {}).each {|k, v| params[k.to_sym] = v }

      raise MarkdownError, "Markdown parse failed" if params.empty? || body.strip.empty?

      [params, body, ERB::Util.html_escape(body.to_s.split(/\n{2,}/).first.to_s.strip)]
    end
  end
end
