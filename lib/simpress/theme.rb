# frozen_string_literal: true

require "tilt"
require "simpress/config"
require "simpress/context"

module Simpress
  class Theme
    class << self
      KEY = :simpress_tilt_caches

      def render(template, data)
        Simpress::Context.update(data)
        tilt = create_tilt(template)
        tilt.render(Simpress::Context.instance.to_scope)
      end

      def render_parital(template, data)
        tilt = create_tilt(template)
        tilt.render(data.each_with_object(Object.new) {|(k, v), obj| obj.instance_variable_set("@#{k}", v) })
      end

      def exist?(template)
        File.exist?(fetch_template_file(template))
      end

      def clear
        Thread.current[KEY] = nil
      end

      private

      def tilt_caches
        Thread.current[KEY] ||= {}
      end

      def create_tilt(template)
        filename = fetch_template_file(template)
        tilt_caches.fetch(filename) do
          tilt = Tilt::ErubiTemplate.new(filename)
          tilt_caches[filename] = tilt
        end
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
