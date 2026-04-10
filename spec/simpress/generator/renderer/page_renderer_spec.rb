# frozen_string_literal: true

require "simpress/generator/renderer/page_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::PageRenderer do
  let(:page)  { build(:post, title: "About", permalink: "about", layout: "page", index: false) }
  let(:pages) { [page] }

  before do
    allow(Simpress::Logger).to receive(:info)
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/page/about.html")
    end

    it "writes html for each page" do
      described_class.generate_html(pages)
      expect(Simpress::Theme).to have_received(:render).with("page", post: page)
      expect(Simpress::Writer).to have_received(:write)
      expect(Simpress::Logger).to have_received(:info).with("[BUILD PAGE]: About public/page/about.html")
    end
  end

  describe ".generate_json" do
    let(:expected_page_json) { Simpress::JSON.dump(page, keys: described_class::DATA_JSON_KEYS) }

    before do
      allow(Simpress::Writer).to receive(:write).with(anything, expected_page_json).and_yield("public/page/about.json")
    end

    it "writes json for each page with permitted keys" do
      described_class.generate_json(pages)
      expect(Simpress::Writer).to have_received(:write).with(anything, expected_page_json)
      expect(Simpress::Logger).to have_received(:info).with("[BUILD PAGE]: About public/page/about.json")
    end
  end
end
