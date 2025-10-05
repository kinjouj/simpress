# frozen_string_literal: true

module Simpress
  module Parser
    class << self
      def parse(file)
        params, body = Simpress::Markdown.parse(File.read(file))
        raise "parse failed: #{file}" if params.blank? || body.blank?

        basename            = File.basename(file, ".*")
        content, image, toc = Simpress::Parser::Redcarpet.render(body)
        params[:id]         = Digest::SHA1.hexdigest(file)
        params[:content]    = content
        params[:toc]        = toc || []
        params[:layout]     = (params[:layout] || "post").to_sym
        params[:published]  = params.fetch(:published, true)
        params[:cover] ||= image || "/images/no_image.png"

        parse_datetime!(params, basename)
        parse_permalink!(params, basename)
        parse_categories!(params)

        Simpress::Model::Post.new(params)
      end

      def parse_datetime!(params, basename)
        if params[:date].blank?
          y, m, d = basename.scan(/\A(\d{4})-(\d{1,2})-(\d{1,2})/).flatten
          params[:date] = DateTime.new(y.to_i, m.to_i, d.to_i) unless [ y, m, d ].include?(nil)
          raise "invalid date" if params[:date].blank?
        else
          params[:date] = DateTime.parse(params[:date].to_s)
        end
      end

      def parse_permalink!(params, basename)
        params[:permalink] = "/#{params[:date].strftime('%Y/%m')}/#{basename}" if params[:permalink].blank?
      end

      def parse_categories!(params)
        params[:categories] = Array(params[:categories]).compact
        params[:categories].map! {|category| Simpress::Model::Category.new(category) }
      end
    end

    private_class_method :parse_datetime!, :parse_permalink!, :parse_categories!
  end
end
