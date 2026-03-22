# frozen_string_literal: true

require "simpress/uri"

describe Simpress::Uri do
  context "初期化" do
    it "引数なしで初期化した場合、空文字を返す" do
      expect(described_class.new.build).to eq("")
    end

    it "パスを渡して初期化した場合、そのパスを返す" do
      expect(described_class.new("articles").build).to eq("articles")
    end
  end

  describe "#path" do
    it "単一セグメントを追加できる" do
      uri = described_class.new("articles").path("ruby")
      expect(uri.build).to eq("articles/ruby")
    end

    it "複数セグメントを一度に追加できる" do
      uri = described_class.new("articles").path("ruby", "tips")
      expect(uri.build).to eq("articles/ruby/tips")
    end

    it "先頭スラッシュ付きのセグメントを正規化する" do
      uri = described_class.new("articles").path("/ruby")
      expect(uri.build).to eq("articles/ruby")
    end

    it "Symbol を文字列に変換する" do
      uri = described_class.new("articles").path(:ruby)
      expect(uri.build).to eq("articles/ruby")
    end
  end

  describe "#with_ext" do
    it "拡張子のないパスに拡張子を付ける" do
      uri = described_class.new("articles/ruby").with_ext("html")
      expect(uri.build).to eq("articles/ruby.html")
    end

    it "既存の拡張子を上書きする" do
      uri = described_class.new("articles/ruby.md").with_ext("html")
      expect(uri.build).to eq("articles/ruby.html")
    end

    it "with_ext を呼ばない場合は拡張子を付けない" do
      uri = described_class.new("articles/ruby")
      expect(uri.build).to eq("articles/ruby")
    end
  end
end
