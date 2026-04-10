# frozen_string_literal: true

require "simpress/sitemap"

describe Simpress::Sitemap do
  let(:hostname) { "https://example.com" }

  before do
    allow(Simpress::Writer).to receive(:write)
    allow(Simpress::Logger).to receive(:debug)
  end

  describe ".build" do
    it "raises error when block is not given" do
      expect { described_class.build(hostname) }.to raise_error("ERROR")
    end

    it "initializes, yields block, and writes sitemap" do
      described_class.build(hostname) { url(file: "index.html", lastmod: "2026-01-01") }
      expect(Simpress::Writer).to have_received(:write).with("sitemap.xml", anything)
    end
  end

  describe "#url" do
    let(:xml) do
      sitemap = described_class.send(:new, hostname) { url(file: "test.html", lastmod: "2026-01-01", changefreq: "daily") }
      Ox.dump(sitemap.instance_variable_get(:@doc))
    end

    it "includes loc element with full url" do
      expect(xml).to include("<loc>https://example.com/test.html</loc>")
    end

    it "includes lastmod element" do
      expect(xml).to include("<lastmod>2026-01-01</lastmod>")
    end

    it "includes changefreq attribute" do
      expect(xml).to include('changefreq="daily"')
    end
  end

  describe "#write" do
    it "calls Simpress::Writer and logs debug message" do
      sitemap = described_class.send(:new, hostname) do
        url(file: "page1.html", lastmod: "2026-01-01")
        url(file: "page2.html", lastmod: "2026-01-01")
      end

      sitemap.write
      expect(Simpress::Writer).to have_received(:write).with("sitemap.xml", instance_of(String))
      expect(Simpress::Logger).to have_received(:debug).with("generated sitemap.xml: 2")
    end
  end
end
