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
        assign_id!
        assign_date!
        assign_index!
        assign_draft!
        assign_markdown!
        assign_layout!
        assign_permalink!
      end

      def assign_id!
        @params[:id] = XXhash.xxh64(@file).to_s
      end

      def assign_date!
        @params[:date] = parse_datetime
      end

      def assign_index!
        @params[:index] = @params.fetch(:index, true)
      end

      def assign_draft!
        @params[:draft] = @params.fetch(:draft, false)
      end

      def assign_markdown!
        @params[:markdown] = @markdown
      end

      def assign_layout!
        @params[:layout] ||= "page"
      end

      def assign_permalink!
        @params[:permalink] ||= parse_permalink
      end

      def parse_datetime
        date = @params[:date]
        return date.to_time if date.respond_to?(:to_time)

        parsed = if date
                   Time.parse(date.to_s) rescue nil # rubocop:disable Style/RescueModifier
                 else
                   TIME_REGEX.match(@basename)&.then {|m| Time.new(*m.captures) }
                 end

        @params[:index] = false unless parsed
        parsed || Time.now
      end

      def parse_permalink
        date = @params[:date]
        Simpress::Path.new.path(date.year, date.month.to_s.rjust(2, "0"), @basename).build
      end
    end
  end
end
