# frozen_string_literal: true

require "simpress/paginator"

describe Simpress::Paginator do
  context "Paginatorビルダーで正しくインスタンスを作成する場合" do
    it "IndexとPost のインスタンスが正しく生成されること" do
      paginator1 = described_class.builder.maxpage(10).page(2).build
      expect(paginator1).to be_is_a(Simpress::Paginator::Index)

      paginator2 = described_class.builder.maxpage(10).page(2).prefix("/abc").build
      expect(paginator2).to be_is_a(Simpress::Paginator::Index)

      paginator3 = described_class.builder.posts([1, 2, 3]).build
      expect(paginator3).to be_is_a(Simpress::Paginator::Post)
    end
  end

  context "必要な情報が不足している場合" do
    it "NotImplementedError が発生すること" do
      expect { described_class.builder.build }.to raise_error(NotImplementedError)
    end
  end
end
