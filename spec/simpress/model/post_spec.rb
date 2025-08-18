# frozen_string_literal: true

require "simpress/config"
require "simpress/theme"
require "simpress/model/category"
require "simpress/model/post"

describe Simpress::Model::Post do
  let(:params) do
    {
      title: "title",
      content: "<p>content\n 123</p>",
      toc: [],
      date: DateTime.now,
      permalink: "/test.html",
      categories: [],
      cover: "/images/no_image.png",
      layout: :post,
      published: true
    }
  end

  describe "#new" do
    it "successful" do
      post = described_class.new(params)
      expect(post).to be(post)
    end
  end

  describe "#description" do
    it "コンストラクタパラメータにdescriptionがある場合" do
      params[:description] = "TEST"
      post = described_class.new(params)
      expect(post.description).to eq("TEST")
    end

    it "descriptionによってタグ・スペース等が除去されていること" do
      post = described_class.new(params)
      expect(post.description).to eq("content123")
    end

    it "descriptionが指定している文字列が100文字以上の場合切り捨てられること" do
      params[:content] = "A" * 300
      post = described_class.new(params)
      expect(post.description).to eq("A" * 100)
      expect(post.description.size).to eq(100)
    end
  end
end
