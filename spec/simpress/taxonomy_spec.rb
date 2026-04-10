# frozen_string_literal: true

require "simpress/taxonomy"

describe Simpress::Taxonomy do
  before do
    described_class.clear
    allow(Simpress::Config.instance).to receive(:taxonomies).and_return({ "categories" => { "Ruby" => "ruby" }, "tags" => {} })
  end

  after do
    described_class.clear
  end

  describe ".fetch" do
    it "returns a taxonomy instance" do
      tags = described_class.fetch("tags")
      expect(tags).to be_a(described_class)
      expect(tags.name).to eq "tags"
      expect(tags).to equal(described_class.fetch("tags"))
    end
  end

  describe ".taxonomies" do
    it "includes default and yaml-defined taxonomies" do
      names = described_class.taxonomies.map(&:name)
      expect(names).to include("categories", "tags")
    end
  end

  describe ".slug_for" do
    it "returns the slug for a known taxonomy and term" do
      expect(described_class.slug_for("categories", "Ruby")).to eq "ruby"
    end

    it "returns nil for an unknown term" do
      expect(described_class.slug_for("categories", "Unknown")).to be_nil
    end

    it "returns nil for an unknown taxonomy" do
      expect(described_class.slug_for("unknown", "Ruby")).to be_nil
    end
  end

  describe ".clear" do
    it "resets the internal cache and memoized taxonomies" do
      obj = described_class.fetch("categories")
      described_class.clear
      expect(obj).not_to be(described_class.fetch("categories"))
    end
  end

  describe "#term" do
    it "returns a Term instance for a given name" do
      term = described_class.fetch("categories").term("Ruby")
      expect(term).to be_a(Simpress::Taxonomy::Term)
      expect(term.name).to eq "Ruby"
    end

    it "uses the slug override from taxonomies" do
      term = described_class.fetch("categories").term("Ruby")
      expect(term.key).to eq "ruby"
    end

    it "falls back to to_url when no slug override exists" do
      term = described_class.fetch("categories").term("Unknown")
      expect(term.key).to eq "unknown"
    end

    it "memoizes the term instance within the taxonomy" do
      taxonomy = described_class.fetch("categories")
      expect(taxonomy.term("Ruby")).to equal(taxonomy.term("Ruby"))
    end
  end
end
