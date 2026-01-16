# frozen_string_literal: true

require "simpress/config"

module Simpress
  module Writer
    class << self
      def write(file, data, overwrite = false)
        filepath = File.join(output_dir, file)
        raise "FILE EXISTS: #{filepath}" if !overwrite && File.exist?(filepath)

        FileUtils.mkdir_p(File.dirname(filepath))
        File.write(filepath, data)
        yield filepath if block_given?
      end

      private

      def output_dir
        @output_dir ||= Simpress::Config.instance.output_dir || "public"
      end
    end
  end
end
