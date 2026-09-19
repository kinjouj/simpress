# frozen_string_literal: true

require "simpress/generator/pipeline/archive/post_index"
require "simpress/post"

describe Simpress::Generator::Pipeline::Archive::PostIndex do
  let(:post) { build(:post) }
  let(:posts) { [post] }

  before do
    allow(Simpress::Logger).to receive(:verbose)
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
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD ARCHIVE]: public/index.html")
    end
  end

  describe ".generate_json" do
    let(:expected_page_json) { Simpress::JSON.dump({ posts: [post.to_h(keys: described_class::DATA_JSON_KEYS)], total_pages: 1 }) }

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/page/1.json", anything).and_yield("public/archives/page/1.json")
    end

    it "writes paginated json" do
      described_class.generate_json(posts)
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", expected_page_json)
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD ARCHIVE]: public/archives/page/1.json")
    end
  end
end
