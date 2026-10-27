# frozen_string_literal: true

require "simpress/path"

describe Simpress::Path do
  describe ".wrap" do
    it "既にSimpress::Pathならそのインスタンスを返す" do
      path = described_class.new("/base")
      expect(described_class.wrap(path)).to equal(path)
    end

    it "文字列が渡された場合は文字列の値を保持した新しいインスタンスを生成する" do
      wrapped = described_class.wrap("/base")
      expect(wrapped).to be_a(described_class)
      expect(wrapped.to_s).to eq "/base"
    end
  end

  describe "#path" do
    it "ベースパスと追加の要素を結合する" do
      path = described_class.new("base").path("sub", "dir")
      expect(path.to_s).to eq "base/sub/dir"
    end

    it "結合前に要素の先頭のスラッシュを取り除く" do
      path = described_class.new("base").path("/sub", "/dir/")
      expect(path.to_s).to eq "base/sub/dir/"
    end
  end

  describe "#with_ext" do
    it "ビルドされるパスの拡張子を設定する" do
      path = described_class.new("image.png").with_ext("webp")
      expect(path.to_s).to eq "image.webp"
    end
  end

  describe "#build" do
    it "要素をスラッシュで結合する" do
      path = described_class.new("root").path("a", "b")
      expect(path.build).to eq "root/a/b"
    end

    it "with_extが使われた場合は既存の拡張子を置き換える" do
      path = described_class.new("archive.tar.gz").with_ext("zip")
      expect(path.build).to eq "archive.tar.zip"
    end
  end

  describe "#to_s" do
    it "buildに委譲する" do
      expect(described_class.new("file.html").to_s).to eq("file.html")
    end
  end
end
