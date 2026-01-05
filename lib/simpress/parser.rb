# frozen_string_literal: true

require "date"
require "digest/sha1"
require "pathname"
require "only_blank"
require "simpress/category"
require "simpress/config"
require "simpress/markdown"
require "simpress/parser/redcarpet"
require "simpress/post"

module Simpress
  module Parser
    class ParserError < StandardError; end
    class InvalidDateParseError < ParserError; end

    class << self
      def parse(file)
        params, body, description = Simpress::Markdown.parse(File.read(file))
        content, image, toc       = Simpress::Parser::Redcarpet.render(body)
        basename                  = File.basename(file, ".*")
        initialize_params!(params, file, description, content, image, toc)
        parse_datetime!(params, basename)
        parse_permalink!(params, basename)
        parse_categories!(params)

        Simpress::Post.new(params)
      end

      private

      def initialize_params!(params, file, description, content, image, toc)
        params[:id]          = Digest::SHA1.hexdigest(file)
        params[:description] = description unless params[:description]
        params[:content]     = content
        params[:toc]         = toc || []
        params[:layout]      = params.fetch(:layout, :post).to_sym
        params[:published]   = params.fetch(:published, true)
        params[:cover]       = (image || "/images/no_image.png") unless params[:cover]
      end

      def parse_datetime!(params, basename)
        if params[:date].blank?
          y, m, d = basename.scan(/\A(\d{4})-(\d{1,2})-(\d{1,2})/).flatten
          params[:date] = DateTime.new(y.to_i, m.to_i, d.to_i) unless [y, m, d].include?(nil)
        else
          begin
            params[:date] = DateTime.parse(params[:date].to_s)
          rescue ArgumentError
            raise InvalidDateParseError, "Invalid date format: #{params[:date]}"
          end
        end

        raise InvalidDateParseError, "Date missing or invalid in file #{basename}" if params[:date].blank?
      end

      def parse_permalink!(params, basename)
        return if params[:layout] == :page

        basepath = if params[:permalink].blank?
                     Pathname.new("/").join(params[:date].strftime("%Y/%m"), basename)
                   else
                     Pathname.new(params[:permalink])
                   end

        params[:permalink] = basepath.sub_ext(".#{Simpress::Config.instance.mode}").to_s
      end

      def parse_categories!(params)
        params[:categories] = Array(params[:categories]).compact
        params[:categories].map! {|category_name| Simpress::Category.new(category_name) }
      end
    end
  end
end
