# frozen_string_literal: true

require "oj"
require "simpress/config"
require "simpress/post"

describe Simpress::Post do
  let(:params) do
    {
      id: "abc",
      title: "title",
      description: "content description",
      content: "<p>content\n123</p>",
      toc: [],
      date: Time.new(2025, 1, 1),
      permalink: "/test.html",
      categories: [],
      cover: "/images/no_image.webp",
      layout: :post,
      draft: true,
      markdown: "# Test"
    }
  end

  it "初期化時に各属性が正しく設定されること" do
    post = described_class.new(params)
    expect(post.id).to eq("abc")
    expect(post.title).to eq("title")
    expect(post.content).to eq("<p>content\n123</p>")
    expect(post.toc).to eq([])
    expect(post.date).to eq(Time.new(2025, 1, 1))
    expect(post.permalink).to eq("/test.html")
    expect(post.categories).to eq([])
    expect(post.cover).to eq("/images/no_image.webp")
    expect(post.layout).to eq(:post)
    expect(post.draft).to be_truthy
    expect(post.to_s).to eq("title: /test.html")
  end

  describe "#timestamp" do
    it "タイムスタンプ値が取得できること" do
      post = described_class.new(params)
      expect(post.timestamp).to be_a(Integer)
    end
  end

  describe "#canonical" do
    before do
      allow(Simpress::Config.instance).to receive(:host).and_return("http://localhost")
    end

    it "hostとpermalinkが結合した値が取得できること" do
      post = described_class.new(params)
      expect(post.canonical).to eq("http://localhost/test.html")
    end
  end

  describe "#as_json" do
    it "keysを指定しない場合はすべてのデータが返されること" do
      post = described_class.new(params)
      expect(post.as_json).to eq(
        {
          id: "abc",
          title: "title",
          date: Time.new(2025, 1, 1),
          permalink: "/test.html",
          source: "/test.json",
          categories: [],
          cover: "/images/no_image.webp",
          description: "content description",
          toc: [],
          content: "<p>content\n123</p>"
        }
      )
    end

    it "keysを指定した場合は指定したキーだけが返されること" do
      post = described_class.new(params)
      expect(post.as_json(keys: [:id])).to eq({ id: "abc" })
    end
  end

  describe "#to_json" do
    it "contentを含めずにJSON文字列を返すこと" do
      post = described_class.new(params)
      parsed_json = Oj.load(post.to_json(keys: [:title]), symbolize_names: true)
      expect(parsed_json).to eq({ title: "title" })
    end
  end
end
