# frozen_string_literal: true

require "simpress/generator/pipeline/permalink"
require "simpress/entry"

describe Simpress::Generator::Pipeline::Permalink do
  let(:entry) { build(:entry, title: "My Entry", permalink: "my-entry", layout: "page", date: Time.new(2026, 1, 1)) }

  before do
    allow(Simpress::Logger).to receive(:verbose)
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/my-entry.html")
      allow(File).to receive(:utime)
    end

    it "HTMLを書き出してエントリのmtimeを設定する" do
      described_class.generate_html(entry)
      expect(Simpress::Theme).to have_received(:render).with("page", entry: entry)
      expect(Simpress::Writer).to have_received(:write).with("my-entry.html", "<html>content</html>")
      expect(File).to have_received(:utime).with(entry.date, entry.date, "public/my-entry.html")
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD PAGE]: My Entry public/my-entry.html")
    end
  end

  describe ".generate_json" do
    let(:expected_entry_json) { Simpress::JSON.dump(entry, keys: described_class::DATA_JSON_KEYS) }

    before do
      allow(Simpress::Writer).to receive(:write).with(anything, expected_entry_json).and_yield("public/my-entry.json")
    end

    it "許可されたキーでJSONを書き出す" do
      described_class.generate_json(entry)
      expect(Simpress::Writer).to have_received(:write).with(anything, expected_entry_json)
      expect(Simpress::Logger).to have_received(:verbose).with("[BUILD PAGE]: My Entry public/my-entry.json")
    end
  end
end
