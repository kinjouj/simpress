# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"
require "simpress/generator/pipeline/permalink"

describe Simpress::Generator::Pipeline::Permalink do
  let(:entry) do
    build(:entry, title: "My Entry", permalink: "my-entry", layout: "page", date: Time.new(2026, 1, 1))
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
      allow(Simpress::Writer).to receive(:write).and_yield("public/my-entry.html")
      allow(File).to receive(:utime)
    end

    it "HTML is generated, mtime set" do
      expect { described_class.generate_html(entry) }.to output(%r{\[BUILD PAGE\]: My Entry public/my-entry\.html}).to_stdout_from_any_process
      expect(Simpress::Theme).to have_received(:render).with("page", entry: entry)
      expect(Simpress::Writer).to have_received(:write).with("my-entry.html", "<html>content</html>")
      expect(File).to have_received(:utime).with(entry.date, entry.date, "public/my-entry.html")
    end
  end

  describe ".generate_json" do
    let(:expected_entry_json) do
      Simpress::JSON.dump(entry, keys: described_class::DATA_JSON_KEYS)
    end

    before do
      allow(Simpress::Writer).to receive(:write).with(anything, expected_entry_json).and_yield("public/my-entry.json")
    end

    it "JSON is generated, keys filtered" do
      expect { described_class.generate_json(entry) }.to output(%r{\[BUILD PAGE\]: My Entry public/my-entry\.json}).to_stdout_from_any_process
      expect(Simpress::Writer).to have_received(:write).with(anything, expected_entry_json)
    end
  end
end
