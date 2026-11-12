# frozen_string_literal: true

require "simpress/entry"
require "simpress/generator/pipeline/archive/monthly_index"

describe Simpress::Generator::Pipeline::Archive::MonthlyIndex do
  let(:entry) do
    build(:entry)
  end

  let(:monthly_archives) do
    { [2026, 1] => [entry] }
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
      allow(Simpress::Writer).to receive(:write).and_yield("public/archives/2026/01/index.html")
    end

    it "/archives/2026/01/index.html is generated" do
      expect { described_class.generate_html(monthly_archives) }.to output(%r{\[BUILD ARCHIVE\]: public/archives/2026/01/index\.html}).to_stdout_from_any_process
      expect(Simpress::Theme).to have_received(:render)
      expect(Simpress::Writer).to have_received(:write).with("/archives/2026/01/index.html", "<html>content</html>")
    end
  end

  describe ".generate_json" do
    let(:expected_index_json) do
      Simpress::JSON.dump({ entries: [entry], total_pages: 1 }, keys: described_class::DATA_JSON_KEYS)
    end

    before do
      allow(Simpress::Writer).to receive(:write).with("/archives/2026/01/1.json", anything).and_yield("public/archives/2026/01/1.json")
    end

    it "/archives/2026/01/1.json is generated" do
      expect { described_class.generate_json(monthly_archives) }.to output(%r{\[BUILD ARCHIVE\]: public/archives/2026/01/1\.json}).to_stdout_from_any_process
      expect(Simpress::Writer).to have_received(:write).with("/archives/2026/01/1.json", expected_index_json)
    end
  end
end
