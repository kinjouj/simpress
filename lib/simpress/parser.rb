# frozen_string_literal: true

require "time"
require "xxhash"

require "simpress/config"
require "simpress/parser/markdown"
require "simpress/post"
require "simpress/taxonomy"
require "simpress/path"

module Simpress
  module Parser
    class << self
      def parse(file)
        params, markdown = Simpress::Parser::Markdown.parse(File.read(file))
        metadata = MetadataBuilder.new(file, params, markdown).build
        Simpress::Post.new(metadata)
      end
    end

    class MetadataBuilder
      TIME_REGEX = /\A(\d{4})-(\d{1,2})-(\d{1,2})/

      def initialize(file, params, markdown)
        @file = file
        @basename = File.basename(file, ".*")
        @params = params
        @markdown = markdown
      end

      def build
        assign_metadata!
        @params
      end

      private

      def assign_metadata!
        @params[:id] = XXhash.xxh64(@file).to_s
        @params[:date] = parse_datetime
        @params[:index] = @params.fetch(:index, true)
        @params[:draft] = @params.fetch(:draft, false)
        @params[:markdown] = @markdown
        @params[:layout] ||= "page"
        @params[:permalink] ||= parse_permalink
      end

      def parse_datetime
        date = @params[:date]
        return date.to_time if date.respond_to?(:to_time)

        parsed = if date
                   Time.parse(date.to_s) rescue nil # rubocop:disable Style/RescueModifier
                 else
                   m = TIME_REGEX.match(@basename)
                   Time.new(*m.captures) if m
                 end

        parsed or raise "Date missing or invalid in file #{@basename}"
      end

      def parse_permalink
        date = @params[:date]
        Simpress::Path.new.path(date.year, date.month.to_s.rjust(2, "0"), @basename).build
      end
    end
  end
end
