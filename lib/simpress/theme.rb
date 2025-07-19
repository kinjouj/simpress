# frozen_string_literal: true

module Simpress
  class Theme
    THEME_DIR  = Simpress::Config.instance.theme_dir  || "themes"
    OUTPUT_DIR = Simpress::Config.instance.output_dir || "public"
    CACHE_DIR  = Simpress::Config.instance.cache_dir  || ".cache"

    class << self
      def render_index(file, data)
        write_file("index", file, data)
      end

      def render_post(file, data)
        write_file("post", file, data)
      end

      def render_page(file, data)
        write_file("page", file, data)
      end

      def render(template, data = {})
        erubis = Erubis::Eruby.load_file(
          "#{THEME_DIR}/#{template}.erb",
          cachename: "#{CACHE_DIR}/#{template}.erb.cache"
        )
        Simpress::Context.update(data)
        erubis.evaluate(Simpress::Context.instance)
      end

      def template_exist?(template)
        File.exist?("#{THEME_DIR}/#{template}.erb")
      end

      private

      def write_file(template, file, data)
        result = render(template, data)
        filepath = File.join(OUTPUT_DIR, file)
        FileUtils.mkdir_p(File.dirname(filepath))
        File.open(filepath, "w") {|file| file.puts(result) }
        filepath
      end
    end
  end
end
