# frozen_string_literal: true

require "xxhash"
require "simpress/category"
require "simpress/config"
require "simpress/parser/markdown"
require "simpress/parser/markdown/processor"
require "simpress/post"
require "simpress/uri"

module Simpress
  module Parser
    class ParseError < StandardError; end

    DEFAULT_COVER = "/images/no_image.webp"
    REGEX_DESC    = /\A\s*(.*?)(?:\r?\n\r?\n|\z)/m
    REGEX_TIME    = /\A(\d{4})-(\d{1,2})-(\d{1,2})/

    class << self
      def parse(file)
        params, body        = Simpress::Parser::Markdown.parse(File.read(file))
        content, image, toc = Simpress::Parser::Markdown::Processor.render(body)
        basename            = File.basename(file, ".*")
        build_params!(params, file, body, content, image, toc)
        parse_datetime!(params, basename)
        parse_permalink!(params, basename)
        Simpress::Post.new(params)
      end

      private

      def build_params!(params, file, body, content, image, toc)
        params[:id]            = XXhash.xxh64(file).to_s
        params[:toc]           = toc
        params[:content]       = content
        params[:markdown]      = body
        params[:categories]    = Array(params[:categories]).map {|name| Simpress::Category.fetch(name) }
        params[:index]         = params.fetch(:index, true)
        params[:draft]         = params.fetch(:draft, false)
        params[:layout]      ||= "page"
        params[:description] ||= body[REGEX_DESC]&.strip.to_s
        params[:cover]       ||= image || DEFAULT_COVER
      end

      def parse_datetime!(params, basename)
        if params[:date]
          params[:date] = Time.new(params[:date]) unless params[:date].is_a?(Time)
        else
          y, m, d = basename.scan(REGEX_TIME).flatten(1)
          params[:date] = Time.new(y, m, d) if y && m && d
        end

        raise ParseError, "Date missing or invalid in file #{basename}" unless params[:date]
      end

      def parse_permalink!(params, basename)
        return if params[:permalink]

        date  = params[:date]
        year  = date.year
        month = date.month.to_s.rjust(2, "0")
        params[:permalink] = Simpress::Uri.new.path(year, month, basename).build
      end
    end
  end
end
