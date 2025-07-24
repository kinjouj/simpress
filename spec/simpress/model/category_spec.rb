# frozen_string_literal: true

require "simpress/model/category"

describe Simpress::Model::Category do
  describe "メソッドのテスト" do
    let(:category) { Simpress::Model::Category.new("Ruby") }

    context "#new" do
      it "successful" do
        expect(category).not_to be_nil
        expect(category.name).to eq("Ruby")
        expect(category.moved).to eq(false)
        expect(category.count).to eq(1)
      end
    end

    context "#to_url" do
      it "successful" do
        expect(category.to_url).to eq("ruby")
      end
    end

    context "#eql" do
      it "successful" do
        other = Simpress::Model::Category.new("Ruby")
        expect(category).to eql(other)
      end
    end

    context "#hash" do
      it "successful" do
        other = Simpress::Model::Category.new("Ruby")
        expect(category.hash).to eq(other.hash)
      end
    end
  end

  context "Hash or Setのキーにオブジェクトを指定した場合" do
    let(:category1) { Simpress::Model::Category.new("test") }
    let(:category2) { Simpress::Model::Category.new("test") }

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
      expect { Simpress::Model::Category.new(nil) }.to raise_error("category is empty")
      expect { Simpress::Model::Category.new("") }.to  raise_error("category is empty")
    end
  end
end
