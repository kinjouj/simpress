# frozen_string_literal: true

require "xxhash"

require "simpress/config"
require "simpress/parser/markdown"
require "simpress/parser/markdown/processor"
require "simpress/post"
require "simpress/taxonomy"
require "simpress/uri"

module Simpress
  module Parser
    class ParseError < StandardError; end

    class << self
      def parse(file)
        params, body = Simpress::Parser::Markdown.parse(File.read(file))
        content, image, toc = Simpress::Parser::Markdown::Processor.render(body)
        metadata = MetadataBuilder.new(file, params, body, content, image, toc).build
        Simpress::Post.new(metadata)
      end
    end

    class MetadataBuilder
      REGEX_DESC    = /\A\s*(.*?)(?:\r?\n\r?\n|\z)/m
      REGEX_TIME    = /\A(\d{4})-(\d{1,2})-(\d{1,2})/
      DEFAULT_COVER = "/images/no_image.webp"

      def initialize(file, params, body, content, image, toc)
        @file     = file
        @basename = File.basename(file, ".*")
        @params   = params
        @body     = body
        @content  = content
        @image    = image
        @toc      = toc
      end

      def build
        assign_metadata!
        @params
      end

      private

      def assign_metadata!
        @params[:id]            = XXhash.xxh64(@file).to_s
        @params[:date]          = parse_datetime
        @params[:content]       = @content
        @params[:toc]           = @toc
        @params[:index]         = @params.fetch(:index, true)
        @params[:draft]         = @params.fetch(:draft, false)
        @params[:markdown]      = @body
        @params[:permalink]   ||= parse_permalink
        @params[:layout]      ||= "page"
        @params[:cover]       ||= @image || DEFAULT_COVER
        @params[:description] ||= @body[REGEX_DESC].strip.to_s
      end

      def parse_datetime
        date = @params[:date]
        return date.to_time if date.respond_to?(:to_time)

        parsed = if date
                   Time.parse(date.to_s)
                 else
                   m = REGEX_TIME.match(@basename)
                   Time.new(*m.captures) if m
                 end

        parsed || raise(ParseError, "Date missing or invalid in file #{@basename}")
      end

      def parse_permalink
        date = @params[:date]
        Simpress::Uri.new.path(date.year, date.month.to_s.rjust(2, "0"), @basename).build
      end
    end
  end
end
