# frozen_string_literal: true

module Simpress
  module Parser
    class ParserError < StandardError; end
    class InvalidDateParseError < ParserError; end

    class << self
      def parse(file)
        params, body, description = Simpress::Markdown.parse(File.read(file))
        content, image, toc       = Simpress::Parser::Redcarpet.render(body)
        basename = File.basename(file, ".*")
        initialize_params!(params, file, description, content, image, toc)
        parse_datetime!(params, basename)
        parse_permalink!(params, basename)
        parse_categories!(params)
        Simpress::Model::Post.new(params)
      end

      def initialize_params!(params, file, description, content, image, toc)
        params[:id]          = Digest::SHA1.hexdigest(file)
        params[:description] = description
        params[:content]     = content
        params[:toc]         = toc || []
        params[:layout]      = params.fetch(:layout, :post).to_sym
        params[:published]   = params.fetch(:published, true)
        params[:cover]       = (image || "/images/no_image.png") unless params[:cover]
      end

      def parse_datetime!(params, basename)
        if params[:date].blank?
          y, m, d = basename.scan(/\A(\d{4})-(\d{1,2})-(\d{1,2})/).flatten
          params[:date] = DateTime.new(y.to_i, m.to_i, d.to_i) unless [ y, m, d ].include?(nil)
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
        params[:permalink] = Pathname.new("/").join(params[:date].strftime("%Y/%m"), basename).to_s if params[:permalink].blank?
        params[:permalink] = "#{params[:permalink]}.#{Simpress::Config.instance.mode}"
      end

      def parse_categories!(params)
        params[:categories] = Array(params[:categories]).compact
        params[:categories].map! {|category_name| Simpress::Model::Category.new(category_name) }
      end
    end

    private_class_method :initialize_params!, :parse_datetime!, :parse_permalink!, :parse_categories!
  end
end
