# frozen_string_literal: true

require "time"
require "xxhash"

require "simpress/config"
require "simpress/errors"
require "simpress/parser/markdown"
require "simpress/parser/markdown/processor"
require "simpress/post"
require "simpress/taxonomy"
require "simpress/uri"

module Simpress
  module Parser
    class << self
      def parse(file)
        params, markdown = Simpress::Parser::Markdown.parse(File.read(file))
        content, renderer = Simpress::Parser::Markdown::Processor.render(markdown)
        metadata = MetadataBuilder.new(file, params, markdown, content, renderer).build
        Simpress::Post.new(metadata)
      end
    end

    class MetadataBuilder
      DESC_REGEX    = /\A\s*(.*?)(?:\r?\n\r?\n|\z)/m
      TIME_REGEX    = /\A(\d{4})-(\d{1,2})-(\d{1,2})/
      DEFAULT_COVER = "/images/no_image.webp"

      def initialize(file, params, markdown, content, renderer)
        @file     = file
        @basename = File.basename(file, ".*")
        @params   = params
        @markdown = markdown
        @content  = content
        @image    = renderer.primary_image
        @toc      = renderer.toc
        @links    = renderer.links
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
        @params[:markdown]      = @markdown
        @params[:links]         = @links
        @params[:permalink]   ||= parse_permalink
        @params[:layout]      ||= "page"
        @params[:cover]       ||= @image || DEFAULT_COVER
        @params[:description] ||= @markdown[DESC_REGEX].strip.to_s
      end

      def parse_datetime
        date = @params[:date]
        return date.to_time if date.respond_to?(:to_time)

        parsed = if date
                   Time.parse(date.to_s)
                 else
                   m = TIME_REGEX.match(@basename)
                   Time.new(*m.captures) if m
                 end

        parsed || raise(Simpress::Errors::ParseError, "Date missing or invalid in file #{@basename}")
      end

      def parse_permalink
        date = @params[:date]
        Simpress::Uri.new.path(date.year, date.month.to_s.rjust(2, "0"), @basename).build
      end
    end
  end
end
