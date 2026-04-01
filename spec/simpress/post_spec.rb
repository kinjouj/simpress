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
      cover: "/images/no_image.webp",
      draft: true,
      index: true,
      markdown: "# Test"
    }
  end

  describe "#initialize" do
    it "正常にインスタンスが生成できパラメーターにアクセスできること" do
      post = described_class.new(params)
      expect(post.id).to eq("abc")
      expect(post.title).to eq("title")
      expect(post.content).to eq("<p>content\n123</p>")
      expect(post.toc).to eq([])
      expect(post.date).to eq(Time.new(2025, 1, 1))
      expect(post.permalink).to eq("/test.html")
      expect(post.categories).to eq([])
      expect(post.cover).to eq("/images/no_image.webp")
      expect(post.index).to be_truthy
      expect(post.draft).to be_truthy
    end
  end

  describe "#timestamp" do
    it "タイムスタンプ値が取得できること" do
      post = described_class.new(params)
      expect(post.timestamp).to be_a(Integer)
    end
  end

  describe "#to_h" do
    it "keysを指定した場合は指定したキーだけが返されること" do
      post = described_class.new(params)
      expect(post.to_h(keys: [:title])).to eq({ title: "title" })
    end

    it "keysを指定しない場合はPERMITTED_JSON_KEYSを元にしたデータになること" do
      post = described_class.new(params)
      expect(post.to_h).not_to be_empty
    end
  end

  describe "#as_json" do
    it "keysを指定した場合は指定したキーだけが返されること" do
      post = described_class.new(params)
      expect(post.as_json(keys: [:id])).to eq({ id: "abc" })
    end

    it "keysを指定しない場合はPERMITTED_JSON_KEYSを元にしたデータになること" do
      post = described_class.new(params)
      expect(post.as_json).not_to be_empty
    end
  end

  describe "#to_json" do
    it "contentを含めずにJSON文字列を返すこと" do
      post = described_class.new(params)
      parsed_json = Simpress::JSON.load(post.to_json(keys: [:title]), symbolize_names: true)
      expect(parsed_json).to eq({ title: "title" })
    end
  end
end
