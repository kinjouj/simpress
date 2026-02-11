# frozen_string_literal: true

require "tilt"
require "simpress/context"

module Simpress
  class Theme
    class << self
      def render(template, data)
        Simpress::Context.update(data)
        render_internal(template, Simpress::Context.to_scope)
      end

      def render_partial(template, data = {})
        scope = Simpress::Context::Scope.new(data)
        render_internal(template, scope)
      end

      def clear
        @tilt_caches = {}
        @theme_dir = nil
      end

      private

      def create_tilt(template)
        filename = File.join(theme_dir, "#{template}.erb")
        tilt_caches[filename] ||= Tilt::ErubiTemplate.new(filename)
      end

      def render_internal(template, scope)
        tilt = create_tilt(template)
        tilt.render(scope)
      end

      def tilt_caches
        @tilt_caches ||= {}
      end

      def theme_dir
        "theme"
      end
    end
  end
end
