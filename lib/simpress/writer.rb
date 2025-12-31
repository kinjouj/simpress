# frozen_string_literal: true

require "simpress/config"

module Simpress
  module Writer
    def self.write(file, data)
      filepath = File.expand_path(File.join(output_dir, file))
      raise "FILE EXISTS: #{filepath}" if File.exist?(filepath)

      FileUtils.mkdir_p(File.dirname(filepath))
      File.write(filepath, data)
      yield filepath if block_given?
    end

    def self.output_dir
      Simpress::Config.instance.output_dir || "public"
    end

    private_class_method :output_dir
  end
end
