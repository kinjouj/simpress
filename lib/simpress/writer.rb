# frozen_string_literal: true

require "fileutils"
require "simpress/config"

module Simpress
  module Writer
    class FileExistsError < StandardError; end

    class << self
      def write(file, data)
        filepath = File.join(Simpress::Config.output_dir, file)
        raise FileExistsError, "FILE EXISTS: #{filepath}" if File.exist?(filepath)

        FileUtils.mkdir_p(File.dirname(filepath))
        File.write(filepath, data)
        yield filepath if block_given?
      end
    end
  end
end
