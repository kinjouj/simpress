# frozen_string_literal: true

module Simpress
  module Plugin
    class Sample
      extend Simpress::Plugin

      def self.run(posts, _, _)
        Simpress::Writer.write("count.txt", posts.size)
      end
    end
  end
end
