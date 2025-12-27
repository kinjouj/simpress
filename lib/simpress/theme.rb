# frozen_string_literal: true

module Simpress
  class Theme
    class << self
      KEY = :simpress_erubis_caches

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

      def erubis_caches
        Thread.current[KEY] ||= {}
      end

      def create_erubis(template)
        filename = fetch_template_file(template)
        raise "template missing: #{filename}" unless exist?(template)

        erubis = erubis_caches[filename]

        if erubis.nil?
          begin
            erubis = Erubis::Eruby.new(File.read(filename))
            erubis.filename = filename
            erubis_caches[filename] = erubis
          rescue StandardError => e
            raise "Failed template error: #{e}"
          end
        end

        erubis
      end

      def theme_dir
        Simpress::Config.instance.theme_dir || "theme"
      end

      def fetch_template_file(template)
        File.join(theme_dir, "#{template}.erb")
      end
    end

    private_class_method :erubis_caches, :create_erubis, :theme_dir, :fetch_template_file
  end
end
