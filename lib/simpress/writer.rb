# frozen_string_literal: true

module Simpress
  module Writer
    OUTPUT_DIR = Simpress::Config.instance.output_dir || "public"

    def self.write(file, data)
      filepath = File.expand_path(File.join(OUTPUT_DIR, file))
      raise "FILE EXISTS: #{filepath}" if File.exist?(filepath)

      FileUtils.mkdir_p(File.dirname(filepath))
      File.write(filepath, data)
      yield filepath if block_given?
    end
  end
end
