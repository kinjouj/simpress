# frozen_string_literal: true

require "simpress/category"

describe Simpress::Category do
  before do
    described_class.clear
  end

  context "新しいカテゴリーを作成する場合" do
    it "カテゴリーが正しく初期化されること" do
      category = described_class.fetch("Ruby")
      expect(category.key).to eq("ruby")
      expect(category.name).to eq("Ruby")
      expect(category.count).to eq(1)
    end
  end

  describe "#increment!" do
    it "正しくcountが+1されること" do
      category = described_class.fetch("Ruby")
      expect(category.count).to eq(1)
      category.increment!
      expect(category.count).to eq(2)
    end
  end

  describe "#as_json" do
    it "正しいハッシュ形式に変換されること" do
      category = described_class.fetch("Ruby")
      expect(category.as_json).to include(key: "ruby", name: "Ruby")
    end
  end

  describe "#to_json" do
    it "JSONデータが取得できること" do
      category = described_class.fetch("Ruby")
      expect(category.to_json).not_to be_empty
    end
  end
end
