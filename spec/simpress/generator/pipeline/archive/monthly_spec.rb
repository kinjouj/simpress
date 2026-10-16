# frozen_string_literal: true

require "simpress/entry"
require "simpress/generator/pipeline/archive/monthly"

describe Simpress::Generator::Pipeline::Archive::Monthly do
  let(:entry) { build(:entry) }
  let(:monthly_archives) { { [2026, 1] => [entry] } }
  let(:verbose_messages) { [] }

  before do
    allow(Simpress::Logger).to receive(:verbose) {|&block| verbose_messages << block.call }
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/2026/01/index.html")
    end

    it "各月についてHTMLをレンダリングして書き出す" do
      described_class.generate_html(monthly_archives)
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/archives/2026/01/index.html", "<html>content</html>")
      expect(verbose_messages).to include("[BUILD ARCHIVE]: public/archives/2026/01/index.html")
    end
  end

  describe ".generate_json" do
    let(:expected_index_json) { Simpress::JSON.dump({ entries: [entry.to_h(keys: described_class::DATA_JSON_KEYS)], total_pages: 1 }) }

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/2026/01/1.json", anything).and_yield("public/archives/2026/01/1.json")
    end

    it "各月についてJSONを書き出す" do
      described_class.generate_json(monthly_archives)
      expect(Simpress::Writer).to have_received(:write).with("/archives/2026/01/1.json", expected_index_json)
      expect(verbose_messages).to include("[BUILD ARCHIVE]: public/archives/2026/01/1.json")
    end
  end
end
