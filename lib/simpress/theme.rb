# frozen_string_literal: true

module Simpress
  class Theme
    THEME_DIR  = Simpress::Config.instance.theme_dir  || "themes"
    CACHE_DIR  = Simpress::Config.instance.cache_dir  || ".cache"

    class << self
      def render(template, data = {})
        Template.render(template, data)
      end

      def clear
        Template.clear
      end

      def template_exist?(template)
        File.exist?("#{THEME_DIR}/#{template}.erb")
      end
    end

    class Template
      @@erubis_caches = {}

      def initialize(template)
        Simpress::Logger.debug("load: #{template}.erb")
        @erubis = Erubis::Eruby.load_file("#{THEME_DIR}/#{template}.erb", cachename: "#{CACHE_DIR}/#{template}.cache")
      end

      def render(data)
        Simpress::Context.update(data)
        @erubis.evaluate(Simpress::Context.instance)
      end

      def self.cache(template)
        erubis = @@erubis_caches["#{THEME_DIR}/#{template}.erb"]

        if erubis.blank?
          erubis = new(template)
          @@erubis_caches["#{THEME_DIR}/#{template}.erb"] = erubis
        end

        erubis
      end

      def self.render(template, data)
        erubis = cache(template)
        erubis.render(data)
      end

      def self.clear
        @@erubis_caches = {}
      end
    end

    private_constant :Template
  end
end
