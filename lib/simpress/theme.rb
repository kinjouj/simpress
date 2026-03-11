# frozen_string_literal: true

require "simpress/context"
require "tilt"

module Simpress
  class Theme
    class << self
      def render(template, data)
        Simpress::Context.update(data)
        render_internal(template, Simpress::Theme::Scope.new(Simpress::Context.to_h))
      end

      def render_partial(template, data)
        render_internal(template, Simpress::Theme::Scope.new(data))
      end

      def clear
        @tilt_caches = {}
      end

      private

      def create_tilt(template)
        filename = "#{theme_dir}/#{template}.erb"
        tilt_caches[filename] ||= Tilt::ErubiTemplate.new(filename, escape: true)
      end

      def tilt_caches
        @tilt_caches ||= {}
      end

      def render_internal(template, scope)
        tilt = create_tilt(template)
        tilt.render(scope)
      end

      # :nocov:
      def theme_dir
        "theme"
      end
      # :nocov:
    end

    class Scope
      def initialize(data = {})
        data.each {|k, v| instance_variable_set("@#{k}", v) }
      end

      def render_partial(template, data = {})
        Simpress::Theme.render_partial(template, data)
      end
    end
  end
end
