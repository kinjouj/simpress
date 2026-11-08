# frozen_string_literal: true

require "simpress/config"
require "simpress/json"
require "simpress/path"

module Simpress
  module Theme
    module Helper
      def self.included(base)
        Scope.include(base) if base.instance_of?(Module)
      end

      def encode_json(data)
        Simpress::JSON.encode(data)
      end

      def absolute_url(path)
        "#{Simpress::Config.host.chomp('/')}#{path}"
      end

      def uri(path)
        Simpress::Path.wrap(path).with_ext("html")
      end

      def flatten_toc(toc)
        toc.flat_map do |heading|
          children = heading[:children].map {|child| { id: child[:id], text: child[:text], depth: 1 } }
          [{ id: heading[:id], text: heading[:text], depth: 0 }] + children
        end
      end
    end
  end
end
