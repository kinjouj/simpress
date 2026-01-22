# frozen_string_literal: true

require "simpress/sitemap"

describe Simpress::Sitemap do
  before do
    allow(Simpress::Writer).to receive(:write)
  end

  it "sitemap.xmlが生成されること" do
    described_class.build("test") do
      url file: "test", lastmod: 1234
    end

    xml_sting = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
        <url>
          <loc>test/test</loc>
          <lastmod>1234</lastmod>
        </url>
      </urlset>
    XML

    expect(Simpress::Writer).to have_received(:write).with("sitemap.xml", xml_sting)
  end

  context "ブロックを渡さなかった場合" do
    it "エラーになること" do
      expect { described_class.build("test") }.to raise_error("ERROR")
    end
  end
end
