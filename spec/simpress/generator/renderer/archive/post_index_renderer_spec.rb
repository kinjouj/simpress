# frozen_string_literal: true

require "simpress/generator/renderer/archive/post_index_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::Archive::PostIndexRenderer do
  let(:post)  { build(:post) }
  let(:posts) { [post] }

  before do
    allow(Simpress::Logger).to receive(:info)
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/index.html")
    end

    it "renders and writes paginated index html" do
      described_class.generate_html(posts)
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/index.html", "<html>content</html>")
      expect(Simpress::Logger).to have_received(:info).with("[BUILD ARCHIVE]: public/index.html")
    end
  end

  describe ".generate_json" do
    let(:expected_page_json) { Simpress::JSON.dump(posts, keys: described_class::DATA_JSON_KEYS) }
    let(:expected_meta_json) { Simpress::JSON.dump({ total_pages: 1 }) }

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/page/1.json", anything).and_yield("public/archives/page/1.json")
      allow(Simpress::Writer).to receive(:write).with("/archives/page/meta.json", anything).and_yield("public/archives/page/meta.json")
    end

    it "writes paginated json" do
      described_class.generate_json(posts)
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", expected_page_json)
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/meta.json", expected_meta_json)
      expect(Simpress::Logger).to have_received(:info).with("[BUILD ARCHIVE]: public/archives/page/1.json")
      expect(Simpress::Logger).to have_received(:info).with("[BUILD ARCHIVE]: public/archives/page/meta.json")
    end
  end
end
