# frozen_string_literal: true

module Simpress
  class Theme
    class << self
      KEY = :erubis_caches

      def create_erubis(template)
        filename      = fetch_template_file(template)
        erubis_caches = Thread.current[KEY] || {}
        erubis        = erubis_caches[filename]

        if erubis.nil?
          erubis = Erubis::Eruby.new(File.read(filename))
          erubis.filename = filename
          erubis_caches[filename] = erubis
          Thread.current[KEY] = erubis_caches
        end

        erubis
      end

      def render(template, data)
        erubis = create_erubis(template)
        Simpress::Context.update(data)
        erubis.evaluate(Simpress::Context.instance)
      end

      def exist?(template)
        File.exist?(fetch_template_file(template))
      end

      def clear
        Thread.current[KEY] = nil
      end

      def theme_dir
        Simpress::Config.instance.theme_dir || "theme"
      end

      def fetch_template_file(template)
        "#{theme_dir}/#{template}.erb"
      end
    end

    private_class_method :create_erubis, :theme_dir, :fetch_template_file
  end
end
