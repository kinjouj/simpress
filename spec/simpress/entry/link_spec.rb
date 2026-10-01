# frozen_string_literal: true

require "simpress/entry/link"

describe Simpress::Entry::Link do
  let(:entry) { build(:entry, id: "entry-123", title: "Sample Title", permalink: "/sample.html") }

  describe ".build" do
    it "returns a Link wrapping the given entry" do
      link = described_class.build(entry)
      expect(link).to be_a(described_class)
      expect(link.id).to eq "entry-123"
      expect(link.title).to eq "Sample Title"
      expect(link.permalink).to eq "/sample.html"
    end

    it "returns nil when entry is nil" do
      expect(described_class.build(nil)).to be_nil
    end
  end

  describe "delegated methods" do
    it "delegates id, title, and permalink to the wrapped entry" do
      link = described_class.new(entry)
      expect(link.id).to eq entry.id
      expect(link.title).to eq entry.title
      expect(link.permalink).to eq entry.permalink
    end
  end

  describe "#to_h" do
    it "returns a hash with only id, title, and permalink" do
      link = described_class.new(entry)
      expect(link.to_h).to eq(id: "entry-123", title: "Sample Title", permalink: "/sample.html")
    end
  end

  describe "#as_json" do
    it "returns the same hash as #to_h" do
      link = described_class.new(entry)
      expect(link.as_json).to eq link.to_h
    end
  end

  describe "#to_json" do
    it "serializes to a JSON string matching to_h" do
      link = described_class.new(entry)
      expect(Simpress::JSON.load(link.to_json, symbolize_names: true)).to eq link.to_h
    end
  end
end
