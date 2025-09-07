# frozen_string_literal: true

module Simpress
  class Theme
    THEME_DIR = Simpress::Config.instance.theme_dir || "theme"

    class << self
      KEY = :erubis_caches

      def render(template, data)
        filename      = "#{THEME_DIR}/#{template}.erb"
        erubis_caches = Thread.current[KEY] || {}
        erubis        = erubis_caches[filename]

        if erubis.nil?
          erubis = Erubis::Eruby.new(File.read(filename))
          erubis.filename = filename
          erubis_caches[filename] = erubis
          Thread.current[KEY] = erubis_caches
        end

        Simpress::Context.update(data)
        erubis.evaluate(Simpress::Context.instance)
      end

      def template_exist?(template)
        File.exist?("#{THEME_DIR}/#{template}.erb")
      end

      def clear
        Thread.current[KEY] = nil
      end
    end
  end
end
