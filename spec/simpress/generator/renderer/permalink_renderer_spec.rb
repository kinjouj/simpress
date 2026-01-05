# frozen_string_literal: true

require "simpress/post"
require "simpress/generator/renderer/permalink_renderer"

describe Simpress::Generator::Renderer::PermalinkRenderer do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:post1) { build_post_data(1) }

  describe ".generate_html" do
    before do
      allow(FileUtils).to receive(:touch)
      allow(Simpress::Theme).to receive(:render).and_return("test")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      expect { described_class.generate_html(post1) }.not_to raise_error
      expect(File).to have_received(:write).with("public/post1.html", "test")
      expect(FileUtils).to have_received(:touch).with("public/post1.html", mtime: post1.date.to_time)
      expect(Simpress::Logger).to have_received(:info)
      expect(Simpress::Theme).to have_received(:render)
    end
  end

  describe ".generate_json" do
    it "正常にgenerate_jsonメソッドが呼ばれること" do
      expect { described_class.generate_json(post1) }.not_to raise_error
      expect(File).to have_received(:write).with("public/post1.json", post1.to_json(include_content: true))
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
