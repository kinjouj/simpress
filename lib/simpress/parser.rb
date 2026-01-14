# frozen_string_literal: true

require "digest/sha1"
require "erb"
require "pathname"
require "simpress/category"
require "simpress/config"
require "simpress/markdown"
require "simpress/parser/redcarpet"
require "simpress/post"

module Simpress
  module Parser
    class ParserError < StandardError; end
    class InvalidDateParseError < ParserError; end

    REGEXP_DESC = /\A.*?(\r?\n){2}/m

    class << self
      def parse(file)
        params, body         = Simpress::Markdown.parse(File.read(file))
        content, image, toc  = Simpress::Parser::Redcarpet.render(body)
        basename             = File.basename(file, ".*")
        params[:markdown]    = body
        params[:id]          = Digest::SHA1.hexdigest(file)
        params[:content]     = content
        params[:toc]         = toc || []
        params[:layout]      = params.fetch(:layout, :post).to_sym
        params[:published]   = params.fetch(:published, true)
        params[:cover]       ||= image || "/images/no_image.png"
        params[:description] ||= ERB::Util.html_escape(body.to_s[REGEXP_DESC].to_s.strip)
        parse_datetime!(params, basename)
        parse_permalink!(params, basename)
        parse_categories!(params)

        Simpress::Post.new(params)
      end

      private

      def parse_datetime!(params, basename)
        if params[:date].nil?
          y, m, d = basename.scan(/\A(\d{4})-(\d{1,2})-(\d{1,2})/).flatten
          params[:date] = Time.new(y.to_i, m.to_i, d.to_i) if y && m && d
        else
          begin
            params[:date] = Time.parse(params[:date].to_s) unless params[:date].is_a?(Time)
          rescue ArgumentError
            raise InvalidDateParseError, "Invalid date format: #{params[:date]}"
          end
        end

        raise InvalidDateParseError, "Date missing or invalid in file #{basename}" if params[:date].nil?
      end

      def parse_permalink!(params, basename)
        return if params[:layout] == :page

        basepath = if params[:permalink].nil?
                     Pathname.new("/").join(params[:date].strftime("%Y/%m"), basename)
                   else
                     Pathname.new(params[:permalink])
                   end

        params[:permalink] = basepath.sub_ext(".#{Simpress::Config.instance.mode}").to_s
      end

      def parse_categories!(params)
        params[:categories] = [*params[:categories]].compact
        params[:categories].map! {|category_name| Simpress::Category.fetch(category_name) }
      end
    end
  end
end
