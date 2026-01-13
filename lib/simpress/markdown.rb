# frozen_string_literal: true

require "erb"
require "front_matter_parser"

module Simpress
  module Markdown
    class MarkdownError < StandardError; end

    REGEXP_DESC = /\A.*?(\r?\n){2}/m
    PARSER = FrontMatterParser::Parser.new(
      :md,
      loader: FrontMatterParser::Loader::Yaml.new(allowlist_classes: [Time])
    )

    def self.parse(txt)
      data   = PARSER.call(txt)
      body   = data.content || ""
      params = {}
      (data.front_matter || {}).each {|k, v| params[k.to_sym] = v }

      raise MarkdownError, "Markdown parse failed" if params.empty? || body.empty?

      description = params.fetch(:description) do
        first_paragraph = body.to_s[REGEXP_DESC].to_s.strip
        ERB::Util.html_escape(first_paragraph)
      end

      [params, body, description]
    end
  end
end
