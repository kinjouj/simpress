# frozen_string_literal: true

require "ox"
require "simpress/writer"

module Simpress
  class Sitemap
    def self.build(hostname, &)
      raise "ERROR" unless block_given?

      sitemap = new(hostname, &)
      sitemap.send(:write)
    end

    def url(file:, lastmod:, **attributes)
      url_el = create_element("url", attributes: attributes)
      url_el << create_element("loc", text: File.join(@hostname, file))
      url_el << create_element("lastmod", text: lastmod.to_s)
      @root << url_el
    end

    private

    def initialize(hostname, &)
      @hostname = hostname
      @doc      = Ox::Document.new(version: "1.0", encoding: "UTF-8")
      @root     = create_element("urlset", attributes: { xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" })
      @doc << @root

      instance_eval(&)
    end

    def create_element(name, attributes: {}, text: nil)
      el = Ox::Element.new(name)
      attributes.each {|k, v| el[k] = v }
      el << text if text
      el
    end

    def write
      Simpress::Writer.write("sitemap.xml", Ox.dump(@doc, with_xml: true))
      Simpress::Logger.debug("generated sitemap.xml: #{@root.nodes.size}")
    end
  end
end
