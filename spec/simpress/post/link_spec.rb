# frozen_string_literal: true

require "simpress/post/link"

describe Simpress::Post::Link do
  let(:post) { build(:post, id: "post-123", title: "Sample Title", permalink: "/sample.html") }

  describe ".build" do
    it "returns a Link wrapping the given post" do
      link = described_class.build(post)
      expect(link).to be_a(described_class)
      expect(link.id).to eq "post-123"
      expect(link.title).to eq "Sample Title"
      expect(link.permalink).to eq "/sample.html"
    end

    it "returns nil when post is nil" do
      expect(described_class.build(nil)).to be_nil
    end
  end

  describe "delegated methods" do
    it "delegates id, title, and permalink to the wrapped post" do
      link = described_class.new(post)
      expect(link.id).to eq post.id
      expect(link.title).to eq post.title
      expect(link.permalink).to eq post.permalink
    end
  end

  describe "#to_h" do
    it "returns a hash with only id, title, and permalink" do
      link = described_class.new(post)
      expect(link.to_h).to eq(id: "post-123", title: "Sample Title", permalink: "/sample.html")
    end
  end

  describe "#as_json" do
    it "returns the same hash as #to_h" do
      link = described_class.new(post)
      expect(link.as_json).to eq link.to_h
    end
  end

  describe "#to_json" do
    it "serializes to a JSON string matching to_h" do
      link = described_class.new(post)
      expect(Simpress::JSON.load(link.to_json, symbolize_names: true)).to eq link.to_h
    end
  end
end
