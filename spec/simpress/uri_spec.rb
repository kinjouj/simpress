# frozen_string_literal: true

require "simpress/uri"

describe Simpress::Uri do
  describe ".wrap" do
    it "returns the same instance if already a Simpress::Uri" do
      uri = described_class.new("/base")
      expect(described_class.wrap(uri)).to equal(uri)
    end

    it "creates a new instance if a string is provided" do
      expect(described_class.wrap("/base")).to be_a(described_class)
    end

    it "preserves the string value when wrapping" do
      expect(described_class.wrap("/base").to_s).to eq "/base"
    end
  end

  describe "#path" do
    it "joins base path with additional parts" do
      uri = described_class.new("base").path("sub", "dir")
      expect(uri.to_s).to eq "base/sub/dir"
    end

    it "removes leading slashes from parts before joining" do
      uri = described_class.new("base").path("/sub", "/dir/")
      expect(uri.to_s).to eq "base/sub/dir/"
    end
  end

  describe "#with_ext" do
    it "sets the extension for the built path" do
      uri = described_class.new("image.png").with_ext("webp")
      expect(uri.to_s).to eq "image.webp"
    end
  end

  describe "#build" do
    it "joins parts using slashes" do
      uri = described_class.new("root").path("a", "b")
      expect(uri.build).to eq "root/a/b"
    end

    it "replaces the existing extension if with_ext is used" do
      uri = described_class.new("archive.tar.gz").with_ext("zip")
      expect(uri.build).to eq "archive.tar.zip"
    end
  end

  describe "#to_s" do
    it "delegates to build" do
      expect(described_class.new("file.html").to_s).to eq("file.html")
    end
  end
end
