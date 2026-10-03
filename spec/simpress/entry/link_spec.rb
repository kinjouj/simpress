# frozen_string_literal: true

require "simpress/entry/link"

describe Simpress::Entry::Link do
  let(:entry) { build(:entry, id: "entry-123", title: "Sample Title", permalink: "/sample.html") }

  describe ".build" do
    it "指定されたエントリをラップしたLinkを返す" do
      link = described_class.build(entry)
      expect(link).to be_a(described_class)
      expect(link.id).to eq entry.id
      expect(link.title).to eq entry.title
      expect(link.permalink).to eq entry.permalink
    end

    it "entryがnilの場合はnilを返す" do
      expect(described_class.build(nil)).to be_nil
    end
  end

  describe "#to_h" do
    it "id、title、permalinkのみを持つハッシュを返す" do
      link = described_class.new(entry)
      expect(link.to_h).to eq(id: "entry-123", title: "Sample Title", permalink: "/sample.html")
    end
  end

  describe "#as_json" do
    it "#to_hと同じハッシュを返す" do
      link = described_class.new(entry)
      expect(link.as_json).to eq(id: "entry-123", title: "Sample Title", permalink: "/sample.html")
    end
  end

  describe "#to_json" do
    it "JSON文字列にシリアライズする" do
      link = described_class.new(entry)
      expect(Simpress::JSON.load(link.to_json, symbolize_names: true)).to eq link.to_h
    end
  end
end
