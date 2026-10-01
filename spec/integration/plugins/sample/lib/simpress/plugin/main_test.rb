# frozen_string_literal: true

module Simpress
  module Plugin
    class MainTest
      extend Simpress::Plugin

      def self.run(entries)
        Simpress::Writer.write("count.txt", entries.size)
        bind_context(sample: "size:: #{entries.size}")
      end
    end
  end
end
