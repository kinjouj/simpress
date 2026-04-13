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
        assign_defaults
        assign_datetime
        assign_permalink
        @params
      end

      private

      def assign_defaults
        @params[:id]            = XXhash.xxh64(@file).to_s
        @params[:toc]           = @toc
        @params[:content]       = @content
        @params[:markdown]      = @body
        @params[:index]         = @params.fetch(:index, true)
        @params[:draft]         = @params.fetch(:draft, false)
        @params[:layout]      ||= "page"
        @params[:description] ||= @body[REGEX_DESC].strip.to_s
        @params[:cover]       ||= @image || DEFAULT_COVER
      end

      def assign_datetime
        date = @params[:date]
        return if date.is_a?(Time)

        if date
          @params[:date] = date.respond_to?(:to_time) ? date.to_time : Time.parse(date)
        else
          m = REGEX_TIME.match(@basename)
          @params[:date] = Time.new(m[1], m[2], m[3]) if m
        end

        raise ParseError, "Date missing or invalid in file #{@basename}" unless @params[:date]
      end

      def assign_permalink
        return if @params[:permalink]

        date  = @params[:date]
        year  = date.year
        month = date.month.to_s.rjust(2, "0")
        @params[:permalink] = Simpress::Uri.new.path(year, month, @basename).build
      end
    end

    class << self
      def parse(file)
        params, body = Simpress::Parser::Markdown.parse(File.read(file))
        return nil if expired?(params)

        content, image, toc = Simpress::Parser::Markdown::Processor.render(body)
        metadata = MetadataBuilder.new(file, params, body, content, image, toc).build
        Simpress::Post.new(metadata)
      end

      private

      def expired?(params)
        raw = params.delete(:expiryDate)
        return false unless raw

        expiry = if raw.is_a?(Time)
                   raw
                 elsif raw.respond_to?(:to_time)
                   raw.to_time
                 else
                   Time.parse(raw.to_s)
                 end

        expiry < Time.now
      end
    end
  end
end
