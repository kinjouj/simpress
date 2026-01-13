# frozen_string_literal: true

require "erubis"
require "simpress/config"
require "simpress/context"

module Simpress
  class Theme
    class << self
      KEY = :simpress_erubis_caches

      def render(template, data)
        Simpress::Context.update(data)
        erubis = create_erubis(template)
        erubis.evaluate(Simpress::Context.instance)
      end

      def exist?(template)
        File.exist?(fetch_template_file(template))
      end

      def clear
        Thread.current[KEY] = nil
      end

      private

      def erubis_caches
        Thread.current[KEY] ||= {}
      end

      def create_erubis(template)
        filename = fetch_template_file(template)
        erubis = erubis_caches[filename]
        return erubis if erubis

        raise "template missing: #{filename}" unless File.exist?(filename)

        begin
          erubis = Erubis::Eruby.load_file(filename, engine: :fast, escape: :none)
          erubis_caches[filename] = erubis
        rescue StandardError => e
          raise "Failed template error: #{e}"
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
  end
end
