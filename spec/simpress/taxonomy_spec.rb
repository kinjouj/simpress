# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"

describe Simpress::Taxonomy do
  before do
    allow(Simpress::Config).to receive(:taxonomies).and_return({ types: ["categories", "tags"] })
  end

  after do
    described_class.clear
  end

  describe ".fetch" do
    it "returns an instance" do
      tags = described_class.fetch("tags")
      expect(tags).to be_a(described_class)
      expect(tags.name).to eq "tags"
      expect(tags).to equal(described_class.fetch("tags"))
    end
  end

  describe ".taxonomies" do
    it "returns the Taxonomies in types" do
      names = described_class.taxonomies.map(&:name)
      expect(names).to eq ["categories", "tags"]
    end

    context "when types is not set" do
      before do
        allow(Simpress::Config).to receive(:taxonomies).and_return({})
      end

      it "returns an empty array" do
        expect(described_class.taxonomies).to eq []
      end
    end
  end

  describe ".resolve" do
    it "resolves terms from params" do
      params = { categories: ["Ruby"], tags: ["oss", "gem"] }
      result = described_class.resolve(params)
      expect(result.keys).to match_array(described_class.taxonomies.map(&:name))
      expect(result["categories"].map(&:name)).to eq ["Ruby"]
      expect(result["tags"].map(&:name)).to eq ["oss", "gem"]
    end

    context "when a name is duplicated" do
      it "merges them into one" do
        result = described_class.resolve({ categories: ["Ruby", "Ruby"], tags: ["oss", "gem", "oss"] })
        expect(result["categories"].map(&:name)).to eq ["Ruby"]
        expect(result["tags"].map(&:name)).to eq ["oss", "gem"]
      end
    end

    context "when params lacks a Taxonomy" do
      it "returns an empty array" do
        result = described_class.resolve({ categories: ["Ruby"] })
        expect(result["tags"]).to eq []
      end
    end

    context "when params is empty" do
      it "returns empty arrays for all" do
        result = described_class.resolve({})
        expect(result.values).to all(eq [])
      end
    end
  end

  describe ".register" do
    let(:entry) do
      build(:entry, categories: ["Ruby"])
    end

    it "registers the entry under terms" do
      described_class.register(entry.taxonomies, entry)

      expect(entry.taxonomies["categories"].first.entries).to include(entry)
    end
  end

  describe ".clear" do
    it "resets the cache" do
      expect { described_class.clear }.to(change { described_class.fetch("categories") })
    end
  end

  describe "#terms" do
    let(:entry) do
      build(:entry)
    end

    it "returns terms with entries" do
      taxonomy = described_class.fetch("categories")
      used = taxonomy.term("Ruby")
      taxonomy.term("Unused")
      used.entries << entry

      expect(taxonomy.terms).to eq({ "Ruby" => used })
    end
  end

  describe "#term" do
    it "returns the same Term" do
      taxonomy = described_class.fetch("categories")
      term = taxonomy.term("Ruby")
      expect(term).to be_a(Simpress::Taxonomy::Term)
      expect(term.name).to eq "Ruby"
      expect(term.key).to eq "ruby"
      expect(taxonomy.term("Ruby")).to equal(term)
    end

    context "when slug override is set" do
      before do
        allow(Simpress::Config).to receive(:taxonomies).and_return({ types: ["categories"], aliases: { categories: { 社会: "social" } } })
      end

      it "uses the alias as the key" do
        term = described_class.fetch("categories").term("社会")
        expect(term.key).to eq "social"
      end
    end

    context "when slug override is absent" do
      it "falls back to to_url" do
        term = described_class.fetch("categories").term("Unknown")
        expect(term.key).to eq "unknown"
      end
    end
  end
end
