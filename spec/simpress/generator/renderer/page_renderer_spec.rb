# frozen_string_literal: true

require "simpress/post"
require "simpress/generator/renderer/page_renderer"

describe Simpress::Generator::Renderer::PageRenderer do
  before do
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:post1) { build_post_data(1, layout: :page) }
  let(:post2) { build_post_data(2, layout: :page) }
  let(:pages) { [post1, post2] }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("test")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(pages)
      expect(File).to have_received(:write).exactly(2).times
      expect(File).to have_received(:write).with("public/page/post1.html", "test")
      expect(File).to have_received(:write).with("public/page/post2.html", "test")
      expect(Simpress::Logger).to have_received(:info).exactly(2).times
      expect(Simpress::Theme).to have_received(:render).exactly(2).times
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(pages)
      expect(File).to have_received(:write).exactly(2).times
      expect(File).to have_received(:write).with("public/page/post1.json", post1.to_json(keys: keys))
      expect(File).to have_received(:write).with("public/page/post2.json", post2.to_json(keys: keys))
      expect(Simpress::Logger).to have_received(:info).exactly(2).times
    end
  end
end
