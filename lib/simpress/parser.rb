# frozen_string_literal: true

module Simpress
  module Parser
    DEFAULT_COVER  = "/images/no_image.png"
    DEFAULT_LAYOUT = "post"

    def self.parse(file)
      params, body = Simpress::Markdown.parse(File.read(file))
      raise "parse failed: #{file}" if params.blank? || body.blank?

      content, image, toc = Simpress::Parser::Redcarpet.render(body)
      params[:layout]     = (params[:layout] || DEFAULT_LAYOUT).to_sym
      params[:cover]      = image || DEFAULT_COVER unless params[:cover]
      params[:published]  = params.fetch(:published, true)
      params[:content]    = content
      params[:toc]        = toc || []
      basename = File.basename(file, ".*")

      if params[:date].blank?
        y, m, d = basename.scan(/\A([\d]{4})-([\d]{1,2})-([\d]{1,2})/).flatten
        params[:date] = DateTime.new(y.to_i, m.to_i, d.to_i) unless [y, m, d].include?(nil)
      else
        params[:date] = params[:date].respond_to?(:to_datetime) ? params[:date].to_datetime : DateTime.parse(params[:date])
      end

      raise "invalid date" unless params[:date]

      params[:permalink]  = "/#{params[:date].strftime('%Y/%m')}/#{basename}.html" if params[:permalink].blank?
      params[:categories] = [params[:categories]].compact unless params[:categories].respond_to?(:map)
      params[:categories].map!(&Simpress::Model::Category.method(:new))
      Simpress::Model::Post.new(params)
    end
  end
end
