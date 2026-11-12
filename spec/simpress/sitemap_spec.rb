# frozen_string_literal: true

require "simpress/sitemap"

describe Simpress::Sitemap do
  before do
    allow(Simpress::Writer).to receive(:write)
    allow(Simpress::Logger).to receive(:debug)
  end

  describe ".build" do
    context "when no block is given" do
      it "raises an error" do
        expect { described_class.build("https://example.com") }.to raise_error("block is required")
      end
    end

    it "writes sitemap.xml from the block" do
      described_class.build("https://example.com") { url(file: "index.html", lastmod: "2026-01-01") }

      expect(Simpress::Writer).to have_received(:write).with("sitemap.xml", anything)
    end
  end

  describe "#url" do
    it "includes loc, lastmod and changefreq" do
      sitemap = described_class.send(:new, "https://example.com")
      sitemap.url(file: "test.html", lastmod: "2026-01-01", changefreq: "daily")
      xml = Ox.dump(sitemap.instance_variable_get(:@doc))

      expect(xml).to include("<loc>https://example.com/test.html</loc>")
      expect(xml).to include("<lastmod>2026-01-01</lastmod>")
      expect(xml).to include('changefreq="daily"')
    end
  end

  describe "#write" do
    it "writes sitemap.xml and prints count" do
      sitemap = described_class.send(:new, "https://example.com")
      sitemap.url(file: "page1.html", lastmod: "2026-01-01")
      sitemap.url(file: "page2.html", lastmod: "2026-01-01")
      sitemap.write

      expect(Simpress::Writer).to have_received(:write).with("sitemap.xml", instance_of(String))
      expect(Simpress::Logger).to have_received(:debug).with("generated sitemap.xml: 2")
    end
  end
end
