# frozen_string_literal: true

module Simpress
  class Theme
    THEME_DIR  = Simpress::Config.instance.theme_dir  || "themes"
    CACHE_DIR  = Simpress::Config.instance.cache_dir  || ".cache"

    class << self
      def render_index(file, data)
        write_file("index", file, data)
      end

      def render_post(file, data)
        write_file("post", file, data)
      end

      def render_page(file, data)
        write_file("page", file, data)
      end

      def render(template, data = {})
        Template.render(template, data)
      end

      def clear
        Template.clear
      end

      def template_exist?(template)
        Template.exist?(template)
      end

      private

      def write_file(template, file, data)
        result = render(template, data)
        Simpress::Writer.write(file, result)
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
        obj = @@erubis_caches["#{THEME_DIR}/#{template}.erb"]

        if obj.nil?
          obj = new(template)
          @@erubis_caches["#{THEME_DIR}/#{template}.erb"] = obj
        end

        obj
      end

      def self.render(template, data)
        erubis = cache(template)
        erubis.render(data)
      end

      def self.exist?(template)
        File.exist?("#{THEME_DIR}/#{template}.erb")
      end

      def self.clear
        @@erubis_caches = {}
      end
    end

    private_constant :Template
  end
end
