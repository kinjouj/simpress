# frozen_string_literal: true

require "tilt"
require "simpress/config"
require "simpress/context"
require "simpress/theme/helper"

module Simpress
  module Theme
    class << self
      def render(template, data)
        hash = Simpress::Context.to_h.merge(data)
        render_internal(template, Simpress::Theme::Scope.new(hash))
      end

      def render_partial(template, data)
        render_internal(template, Simpress::Theme::Scope.new(data))
      end

      def clear
        @tilt_caches = {}
      end

      private

      def tilt_caches
        @tilt_caches ||= {}
      end

      def create_tilt(template)
        filename = "#{Simpress::Config.theme_dir}/#{template}.erb"
        tilt_caches[filename] ||= Tilt::ErubiTemplate.new(filename, escape: true)
      end

      def render_internal(template, scope)
        tilt = create_tilt(template)
        tilt.render(scope)
      end
    end

    class Scope
      include Simpress::Theme::Helper

      def initialize(data = {})
        data.each {|k, v| instance_variable_set("@#{k}", v) }
      end

      def render_partial(template, data = {})
        Simpress::Theme.render_partial(template, data)
      end
    end
  end
end
