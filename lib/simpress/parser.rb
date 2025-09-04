# frozen_string_literal: true

module Simpress
  module Parser
    DEFAULT_COVER = "/images/no_image.png"

    def self.parse(file)
      params, body = Simpress::Markdown.parse(File.read(file))
      raise "parse failed: #{file}" if params.blank? || body.blank?

      basename            = File.basename(file, ".*")
      content, image, toc = Simpress::Parser::Redcarpet.render(body)
      params[:content]    = content
      params[:toc]        = toc || []
      params[:layout]     = (params[:layout] || "post").to_sym
      params[:cover]      = image || DEFAULT_COVER unless params[:cover]
      params[:published]  = params.fetch(:published, true)
      parse_datetime(params, basename)
      parse_permalink(params, basename)
      parse_categories(params)
      Simpress::Model::Post.new(params)
    end

    def self.parse_datetime(params, basename)
      if params[:date].blank?
        y, m, d = basename.scan(/\A(\d{4})-(\d{1,2})-(\d{1,2})/).flatten
        params[:date] = DateTime.new(y.to_i, m.to_i, d.to_i) unless [y, m, d].include?(nil)
        raise "invalid date" if params[:date].blank?
      else
        params[:date] = params[:date].respond_to?(:to_datetime) ? params[:date].to_datetime : DateTime.parse(params[:date])
      end
    end

    def self.parse_permalink(params, basename)
      params[:permalink] = "/#{params[:date].strftime('%Y/%m')}/#{basename}" if params[:permalink].blank?
      params[:permalink] = "#{params[:permalink]}.html"
    end

    def self.parse_categories(params)
      params[:categories] = [params[:categories]].compact unless params[:categories].respond_to?(:map)
      params[:categories].map! {|category| Simpress::Model::Category.new(category) }
    end
  end
end
