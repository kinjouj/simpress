# frozen_string_literal: true

require "simpress/model/category"

describe Simpress::Model::Category do
  let(:category) { described_class.new("Ruby") }

  describe "#new" do
    it "successful" do
      expect(category).not_to be_nil
      expect(category.key).to eq("ruby")
      expect(category.name).to eq("Ruby")
      expect(category.moved).to be_falsy
      expect(category.count).to eq(1)
    end
  end

  describe "#eql" do
    it "successful" do
      other = described_class.new("Ruby")
      expect(category).to eql(other)
    end
  end

  describe "#hash" do
    it "successful" do
      other = described_class.new("Ruby")
      expect(category.hash).to eq(other.hash)
    end
  end

  context "Hash or Setのキーにオブジェクトを指定した場合" do
    let(:category1) { described_class.new("test") }
    let(:category2) { described_class.new("test") }

    it "Hashに同じカテゴリーを追加しても１つしか入らないこと" do
      hash = {}
      hash[category1] = 1
      expect(hash).to include(category2)
      hash[category2] = 2
      expect(hash.size).to eq(1)
    end

    it "Setに同じカテゴリー追加しても１つしか入らないこと" do
      set = Set.new
      set << category1
      set << category2
      expect(set.size).to eq(1)
    end
  end

  context "引数がnilな場合" do
    it "例外が発生すること" do
      expect { described_class.new(nil) }.to raise_error("category is empty")
      expect { described_class.new("") }.to  raise_error("category is empty")
    end
  end
end
