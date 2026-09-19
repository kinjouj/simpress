# frozen_string_literal: true

require "simpress/generator/pipeline/archive/monthly"
require "simpress/post"

describe Simpress::Generator::Pipeline::Archive::Monthly do
  let(:date) { Time.new(2026, 1, 1) }
  let(:post) { build(:post) }
  let(:monthly_archives) { { date => [post] } }

  before do
    allow(Simpress::Logger).to receive(:verbose)
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/2026/01/index.html")
    end

    it "renders and writes paginated html for each month" do
      described_class.generate_html(monthly_archives)
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/archives/2026/01/index.html", "<html>content</html>")
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD ARCHIVE]: public/archives/2026/01/index.html")
    end
  end

  describe ".generate_json" do
    let(:expected_index_json) { Simpress::JSON.dump({ posts: [post.to_h(keys: described_class::DATA_JSON_KEYS)], total_pages: 1 }) }

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/2026/01/1.json", anything).and_yield("public/archives/2026/01/1.json")
    end

    it "writes paginated json for each month" do
      described_class.generate_json(monthly_archives)
      expect(Simpress::Writer).to have_received(:write).with("/archives/2026/01/1.json", expected_index_json)
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD ARCHIVE]: public/archives/2026/01/1.json")
    end
  end
end
