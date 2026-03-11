# frozen_string_literal: true

require "oj"

Oj.default_options = {
  mode: :custom,
  use_to_json: true,
  use_as_json: true,
  time_format: :xmlschema
}

module Simpress
  module JSON
    class << self
      def load(data, options = {})
        Oj.load(data, **options)
      end

      def load_file(data, options = {})
        Oj.load_file(data, **options)
      end

      def dump(obj, options = {})
        Oj.dump(obj, **options)
      end
    end
  end
end
