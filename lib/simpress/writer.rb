# frozen_string_literal: true

module Simpress
  class Writer
    OUTPUT_DIR = Simpress::Config.instance.output_dir || "public"

    class << self
      def write(file, data, create_dir: true)
        filepath = File.join(OUTPUT_DIR, file)
        FileUtils.mkdir_p(File.dirname(filepath)) if create_dir
        File.write(filepath, data)
        filepath
      end
    end
  end
end
