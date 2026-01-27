# frozen_string_literal: true

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
      cover: "/images/no_image.png",
      layout: :post,
      published: true,
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
    expect(post.cover).to eq("/images/no_image.png")
    expect(post.layout).to eq(:post)
    expect(post.published).to be_truthy
    expect(post.to_s).to eq("title: /test.html")
  end

  it "必須フィールドがない場合はCH.validateにより例外が出る" do
    invalid_params = params.dup
    invalid_params.delete(:id)
    expect { described_class.new(invalid_params) }.to raise_error(ClassyHash::SchemaViolationError)
  end

  describe "#timestamp" do
    it "タイムスタンプ値が取得できること" do
      post = described_class.new(params)
      expect(post.timestamp).to be_a(Integer)
    end
  end

  describe "#as_json" do
    it "contentを含めずにJSON用ハッシュを返すこと" do
      post = described_class.new(params)
      expect(post.as_json).to eq(
        {
          id: "abc",
          title: "title",
          toc: [],
          date: Time.new(2025, 1, 1),
          permalink: "/test.html",
          categories: [],
          cover: "/images/no_image.png",
          description: "content description"
        }
      )
      expect(post.as_json).not_to have_key(:content)
    end

    it "include_content:trueを指定した場合はcontentを含めること" do
      post = described_class.new(params)
      expect(post.as_json(include_content: true)).to have_key(:content)
    end
  end

  describe "#to_json" do
    it "contentを含めずにJSON文字列を返すこと" do
      post = described_class.new(params)
      parsed_json = JSON.parse(post.to_json, symbolize_names: true)
      expect(parsed_json).not_to have_key(:content)
    end

    it "include_content:trueを指定した場合はcontentを含めること" do
      post = described_class.new(params)
      parsed_json = JSON.parse(post.to_json(include_content: true), symbolize_names: true)
      expect(parsed_json).to have_key(:content)
    end
  end

  describe "#extract_keywords" do
    it "形態素解析した結果が取得できること" do
      post = described_class.new(params)
      expect(post.extract_keywords).not_to be_empty
    end
  end
end
