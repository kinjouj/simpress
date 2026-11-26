# frozen_string_literal: true

require "simpress/entry"
require "simpress/generator/pipeline/archive/entry_index"

describe Simpress::Generator::Pipeline::Archive::EntryIndex do
  let(:entry) do
    build(:entry)
  end

  before do
    allow(Simpress::Config).to receive(:logging).and_return(true)
  end

  after do
    Simpress::Logger.clear
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/index.html")
    end

    it "outputs /index.html" do
      expect { described_class.generate_html([entry]) }.to output(%r{\[BUILD ARCHIVE\]: public/index\.html}).to_stdout
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/index.html", "<html>content</html>")
    end
  end

  describe ".generate_json" do
    before do
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/page/1.json")
    end

    it "outputs /archives/page/1.json" do
      expect { described_class.generate_json([entry]) }.to output(%r{\[BUILD ARCHIVE\]: public/archives/page/1\.json}).to_stdout
      expect(Simpress::Writer).to have_received(:write) do |path, json|
        expect(path).to eq "/archives/page/1.json"

        data = Simpress::JSON.load(json)
        expect(data["total_pages"]).to eq 1
        expect(data["entries"].map {|e| e["permalink"] }).to eq [entry.permalink]
        expect(data["entries"].first.keys).to match_array(described_class::DATA_JSON_KEYS.map(&:to_s))
      end
    end
  end
end
