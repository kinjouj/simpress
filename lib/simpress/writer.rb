# frozen_string_literal: true

module Simpress
  module Writer
    def self.write(file, data)
      filepath = File.expand_path(File.join(output_directory, file))
      raise "FILE EXISTS: #{filepath}" if File.exist?(filepath)

      FileUtils.mkdir_p(File.dirname(filepath))
      File.write(filepath, data)
      yield filepath if block_given?
    end

    def self.output_directory
      Simpress::Config.instance.output_dir || "public"
    end

    private_class_method :output_directory
  end
end
