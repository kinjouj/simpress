# frozen_string_literal: true

module Simpress
  class Theme
    THEME_DIR = Simpress::Config.instance.theme_dir || "theme"

    class << self
      def render(template, data)
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
        filename = "#{THEME_DIR}/#{template}.erb"
        @erubis = Erubis::Eruby.new(File.read(filename))
        @erubis.filename = filename
      end

      def render(data)
        Simpress::Context.update(data)
        @erubis.evaluate(Simpress::Context.instance)
      end

      def self.render(template, data)
        filename = "#{THEME_DIR}/#{template}.erb"
        erubis = @@erubis_caches[filename]

        if erubis.nil?
          erubis = new(template)
          @@erubis_caches[filename] = erubis
        end

        erubis.render(data)
      end

      def self.clear
        @@erubis_caches.clear
      end
    end

    private_constant :Template
  end
end
