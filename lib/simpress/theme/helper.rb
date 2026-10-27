# frozen_string_literal: true

require "simpress/config"
require "simpress/json"
require "simpress/path"

module Simpress
  module Theme
    module Helper
      def encode_json(data)
        Simpress::JSON.encode(data)
      end

      def canonical(path)
        "#{Simpress::Config.instance.host.chomp('/')}#{uri(path)}"
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
