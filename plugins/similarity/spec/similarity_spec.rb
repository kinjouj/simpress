# frozen_string_literal: true

require "simpress/post"
require "simpress/plugin/similarity"

describe Simpress::Plugin::Similarity do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:binwrite)
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
  end

  after do
    Simpress::Taxonomy.clear
  end

  let(:post1) do
    build(:post,
          id: "post_001",
          title: "東京観光案内",
          date: Time.new(2026, 1, 23, 10, 0, 0),
          permalink: "/posts/tokyo_travel_intro",
          categories: ["旅行"],
          content: "## 浅草寺\n浅草寺は東京の有名寺院です。\n## 東京タワー\n東京タワーも観光名所です。",
          description: "東京観光のおすすめスポット",
          cover: "/images/no_image.png",
          draft: false,
          markdown: "## 浅草寺\n浅草寺は東京の有名寺院です。\n## 東京タワー\n東京タワーも観光名所です。")
  end

  let(:post2) do
    build(:post,
          id: "post_002",
          title: "家庭料理簡単レシピ",
          date: Time.new(2026, 1, 22, 9, 30, 0),
          permalink: "/posts/home_cooking",
          categories: ["料理"],
          content: "## 材料\n鶏肉, 玉ねぎ, にんじん\n## 作り方\n1. 切る\n2. 炒める\n3. 煮る",
          description: "家庭料理の基本レシピ",
          cover: "/images/no_image.png",
          draft: false,
          markdown: "## 材料\n鶏肉, 玉ねぎ, にんじん\n## 作り方\n1. 切る\n2. 炒める\n3. 煮る")
  end

  let(:post3) do
    build(:post,
          id: "post_003",
          title: "東京観光ガイド",
          date: Time.new(2026, 1, 20, 15, 0, 0),
          permalink: "/posts/tokyo_travel_guide",
          categories: ["旅行"],
          content: "## 浅草寺\n浅草寺は有名な観光スポットです。\n## 上野公園\n上野公園も東京の名所です。",
          description: "東京旅行の定番スポット紹介",
          cover: "/images/no_image.png",
          draft: false,
          markdown: "## 浅草寺\n浅草寺は有名な観光スポットです。\n## 上野公園\n上野公園も東京の名所です。")
  end

  let(:post4) do
    build(:post,
          id: "post_004",
          title: "料理レシピ: カレー",
          date: Time.new(2026, 1, 21, 12, 0, 0),
          permalink: "/posts/curry_recipe",
          categories: ["料理"],
          content: "## 材料\n鶏肉, 玉ねぎ, ...\n## 作り方\n1. 切る\n2. 炒める\n3. 煮る",
          description: "家庭で作れるカレー",
          cover: "/images/no_image.png",
          draft: false,
          markdown: "## 材料\n鶏肉, 玉ねぎ, ...\n## 作り方\n1. 切る\n2. 炒める\n3. 煮る")
  end

  let(:post5) do
    build(:post,
          id: "post_005",
          title: "料理レシピ: かんたんパスタ",
          date: Time.new(2026, 1, 21, 12, 0, 0),
          permalink: "/posts/pasta_recipe",
          categories: ["料理"],
          content: "## 麺を茹でる\n## 麺を冷やす\n## 麺に和風ドレッシングをかける\n## 食べる\n## 終わり",
          description: "時短かんたんパスタ",
          cover: "/images/no_image.png",
          draft: false,
          markdown: "## 麺を茹でる\n## 麺を冷やす\n## 麺に和風ドレッシングをかける\n## 食べる\n## 終わり")
  end

  let(:posts) { [post1, post2, post3, post4, post5] }

  it "assigns correct similarity data to each post" do
    described_class.run(posts)

    expect(posts[0]).to respond_to(:similarities)
    expect(posts[0].similarities.size).to eq(1)
    expect(posts[0].similarities.first[0]).to eq("post_003")

    expect(posts[1]).to respond_to(:similarities)
    expect(posts[1].similarities.size).to eq(2)
    expect(posts[1].similarities.map { _1[0] }).to contain_exactly("post_004", "post_005")

    expect(posts[2]).to respond_to(:similarities)
    expect(posts[2].similarities.size).to eq(1)
    expect(posts[2].similarities.first[0]).to eq("post_001")

    expect(posts[3]).to respond_to(:similarities)
    expect(posts[3].similarities.size).to eq(2)
    expect(posts[3].similarities.map { _1[0] }).to contain_exactly("post_002", "post_005")

    expect(posts[4]).to respond_to(:similarities)
    expect(posts[4].similarities.size).to eq(2)
    expect(posts[4].similarities.map { _1[0] }).to contain_exactly("post_004", "post_002")
  end

  context "when cosine similarity returns 0" do
    before do
      cosine_similarities = Simpress::Plugin::Similarity::CosineSimilarity.new(posts)
      allow(cosine_similarities).to receive(:cosine).and_return(0)
      allow(Simpress::Plugin::Similarity::CosineSimilarity).to receive(:new).and_return(cosine_similarities)
    end

    it "sets similarities to empty for all posts" do
      described_class.run(posts)
      posts.each {|post| expect(post.similarities).to be_empty }
    end
  end

  context "when mode is json" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
    end

    it "includes similarities in to_h when content key is present" do
      described_class.run(posts)
      expect(posts[0].to_h(keys: [:title, :content])).to include(:similarities)
    end

    it "excludes similarities from to_h when content key is absent" do
      described_class.run(posts)
      expect(posts[0].to_h(keys: [:title])).not_to include(:similarities)
    end
  end
end
