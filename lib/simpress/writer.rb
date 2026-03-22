# frozen_string_literal: true

require "fileutils"
require "simpress/config"

module Simpress
  module Writer
    class << self
      def write(file, data)
        filepath = File.join(Simpress::Config.output_dir, file)
        raise "FILE EXISTS: #{filepath}" if File.exist?(filepath)

        dirname = File.dirname(filepath)
        FileUtils.mkdir_p(dirname)
        File.write(filepath, data)

        yield filepath if block_given?
      end
    end
  end
end
