# frozen_string_literal: true

require "simpress/config"
require "simpress/json"
require "simpress/uri"

module Simpress
  module Theme
    module Helper
      def json_encode(data)
        Simpress::JSON.encode(data)
      end

      def canonical(path)
        "#{Simpress::Config.instance.host.chomp('/')}#{uri(path)}"
      end

      def uri(path)
        Simpress::Uri.wrap(path).with_ext("html")
      end

      def link_to(text, path, **options)
        attrs = { href: path }.merge(options)
        attrs_str = attrs.map {|k, v| %(#{k}="#{v}") }.join(" ")
        %(<a #{attrs_str}>#{text}</a>)
      end
    end
  end
end
