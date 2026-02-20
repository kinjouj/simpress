# frozen_string_literal: true

require "erb"
require "pathname"
require "xxhash"
require "simpress/category"
require "simpress/config"
require "simpress/parser/markdown"
require "simpress/parser/markdown/processor"
require "simpress/post"

module Simpress
  module Parser
    class ParseError < StandardError; end

    REGEX_DESC = /\A.*?(?:\r?\n){2}/m
    REGEX_TIME = /\A(\d{4})-(\d{1,2})-(\d{1,2})/

    class << self
      def parse(file)
        params, body           = Simpress::Parser::Markdown.parse(File.read(file))
        content, image, toc    = Simpress::Parser::Markdown::Processor.render(body)
        basename               = File.basename(file, ".*")
        params[:markdown]      = body
        params[:id]            = XXhash.xxh64(file)
        params[:toc]           = toc || []
        params[:content]       = content
        params[:layout]        = params.fetch(:layout, "post").to_sym
        params[:draft]         = params.fetch(:draft, false)
        params[:cover]       ||= image || "/images/no_image.webp"
        params[:description] ||= body.to_s[REGEX_DESC]&.strip.to_s

        parse_datetime!(params, basename)
        parse_permalink!(params, basename)
        parse_categories!(params)

        Simpress::Post.new(params)
      end

      private

      def parse_datetime!(params, basename)
        if params[:date]
          begin
            params[:date] = Time.parse(params[:date]) unless params[:date].is_a?(Time)
          rescue ArgumentError
            raise ParseError, "Invalid date format: #{params[:date]}"
          end
        else
          y, m, d = basename.scan(REGEX_TIME).flatten
          params[:date] = Time.new(y.to_i, m.to_i, d.to_i) if y && m && d
        end

        raise ParseError, "Date missing or invalid in file #{basename}" if params[:date].nil?
      end

      def parse_permalink!(params, basename)
        params[:permalink] = File.join("/", params[:date].strftime("%Y/%m"), basename) unless params[:permalink]
      end

      def parse_categories!(params)
        params[:categories] = Array(params[:categories]).compact
        params[:categories].map! {|category_name| Simpress::Category.fetch(category_name) }
      end
    end
  end
end
