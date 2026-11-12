# frozen_string_literal: true

require "simpress/path"

describe Simpress::Path do
  describe ".wrap" do
    context "when given a Simpress::Path" do
      it "returns the same instance" do
        path = described_class.new("/base")
        expect(described_class.wrap(path)).to equal(path)
      end
    end

    context "when given a string" do
      it "returns a new instance" do
        wrapped = described_class.wrap("/base")

        expect(wrapped).to be_a(described_class)
        expect(wrapped.to_s).to eq "/base"
      end
    end
  end

  describe "#path" do
    it "joins base path and parts" do
      path = described_class.new("base").path("sub", "dir")

      expect(path.to_s).to eq "base/sub/dir"
    end

    it "strips leading slashes before joining" do
      path = described_class.new("base").path("/sub", "/dir/")

      expect(path.to_s).to eq "base/sub/dir/"
    end
  end

  describe "#with_ext" do
    it "sets the path extension" do
      path = described_class.new("image.png").with_ext("webp")

      expect(path.to_s).to eq "image.webp"
    end
  end

  describe "#build" do
    it "joins parts with slashes" do
      path = described_class.new("root").path("a", "b")

      expect(path.build).to eq "root/a/b"
    end

    context "when with_ext is used" do
      it "replaces the existing extension" do
        path = described_class.new("archive.tar.gz").with_ext("zip")

        expect(path.build).to eq "archive.tar.zip"
      end
    end
  end

  describe "#to_s" do
    it "returns the path" do
      expect(described_class.new("file.html").to_s).to eq("file.html")
    end
  end
end
