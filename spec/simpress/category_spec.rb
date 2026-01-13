# frozen_string_literal: true

require "simpress/category"

describe Simpress::Category do
  context "新しいカテゴリーを作成する場合" do
    it "カテゴリーが正しく初期化されること" do
      category = described_class.fetch("Ruby")
      expect(category).not_to be_nil
      expect(category.key).to eq("ruby")
      expect(category.name).to eq("Ruby")
      expect(category.count).to eq(1)
    end
  end

  describe "#as_json" do
    it "正しいハッシュ形式でJSONに変換されること" do
      category = described_class.fetch("Ruby")
      expect(category.as_json).to include(key: "ruby", name: "Ruby", count: 1, children: {})
    end
  end

  describe "#to_json" do
    it "正しいJSON文字列として出力されること" do
      category = described_class.fetch("Ruby")
      expect(category.to_json).to eq({ key: "ruby", name: "Ruby", count: 1, children: {} }.to_json)
    end
  end

  context "引数がnilな場合" do
    it "例外が発生すること" do
      expect { described_class.fetch(nil) }.to raise_error("category is empty")
    end
  end
end
