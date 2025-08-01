# frozen_string_literal: true

module Simpress
  module Parser
    DEFAULT_COVER = "/images/no_image.png"

    def self.parse(file)
      params, body = Simpress::Markdown.parse(File.read(file))
      raise "parse failed: #{file}" if !params || !body

      basename = File.basename(file, ".*")
      content, image, toc = Simpress::Parser::Redcarpet.render(body)
      params[:content]    = content
      params[:layout]     = params.fetch(:layout, :post).to_sym
      params[:published]  = params.fetch(:published, true)
      params[:cover]      = image || DEFAULT_COVER unless params[:cover]
      params[:toc]        = toc || []

      if params[:date].nil?
        y, m, d = basename.scan(/\A([\d]{4})-([\d]{1,2})-([\d]{1,2})/).flatten
        params[:date] = DateTime.new(y.to_i, m.to_i, d.to_i) unless [ y, m, d ].include?(nil)
        raise "invalid date" unless params[:date]
      else
        params[:date] = if params[:date].respond_to?(:to_datetime)
                          params[:date].to_datetime
                        else
                          DateTime.parse(params[:date])
                        end
      end

      params[:permalink]  = "/#{params[:date].strftime('%Y/%m')}/#{basename}.html" if params[:permalink].blank?
      params[:categories] = [ params[:categories] ].compact unless params[:categories].respond_to?(:map)
      params[:categories].map!(&Simpress::Model::Category.method(:new))
      Simpress::Model::Post.new(params)
    end
  end
end
