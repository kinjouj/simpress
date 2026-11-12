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

    it "index.html is generated" do
      expect { described_class.generate_html([entry]) }.to output(%r{\[BUILD ARCHIVE\]: public/index\.html}).to_stdout_from_any_process
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/index.html", "<html>content</html>")
    end
  end

  describe ".generate_json" do
    let(:expected_page_json) do
      Simpress::JSON.dump({ entries: [entry], total_pages: 1 }, keys: described_class::DATA_JSON_KEYS)
    end

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/page/1.json", anything).and_yield("public/archives/page/1.json")
    end

    it "/archives/page/1.json is generated" do
      expect { described_class.generate_json([entry]) }.to output(%r{\[BUILD ARCHIVE\]: public/archives/page/1\.json}).to_stdout_from_any_process
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", expected_page_json)
    end
  end
end
