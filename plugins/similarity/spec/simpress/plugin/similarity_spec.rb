# frozen_string_literal: true

require "simpress/taxonomy"
require "simpress/plugin/similarity"

describe Simpress::Plugin::Similarity do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:binwrite)
    allow(Simpress::Config).to receive(:mode).and_return("html")
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Plugin.clear
  end

  let(:markdown1) do
    <<~MARKDOWN
      ## 浅草寺
      浅草寺は東京の有名寺院です。
      ## 東京タワー
      東京タワーも観光名所です。
    MARKDOWN
  end

  let(:markdown2) do
    <<~MARKDOWN
      ## 材料
      鶏肉, 玉ねぎ, にんじん
      ## 作り方
      1. 切る
      2. 炒める
      3. 煮る
    MARKDOWN
  end

  let(:markdown3) do
    <<~MARKDOWN
      ## 浅草寺
      浅草寺は有名な観光スポットです。
      ## 上野公園
      上野公園も東京の名所です。
    MARKDOWN
  end

  let(:markdown4) do
    <<~MARKDOWN
      ## 材料
      鶏肉, 玉ねぎ, ...
      ## 作り方
      1. 切る
      2. 炒める
      3. 煮る
    MARKDOWN
  end

  let(:markdown5) do
    <<~MARKDOWN
      ## 麺を茹でる
      ## 麺を冷やす
      ## 麺に和風ドレッシングをかける
      ## 食べる
      ## 終わり
    MARKDOWN
  end

  let(:entries) do
    [
      build(
        :entry,
        id: "entry_001",
        title: "東京観光案内",
        date: Time.new(2026, 1, 23, 10, 0, 0),
        permalink: "/entries/tokyo_travel_intro",
        categories: ["旅行"],
        description: "東京観光のおすすめスポット",
        cover: "/images/no_image.png",
        draft: false,
        markdown: markdown1
      ),
      build(
        :entry,
        id: "entry_002",
        title: "家庭料理簡単レシピ",
        date: Time.new(2026, 1, 22, 9, 30, 0),
        permalink: "/entries/home_cooking",
        categories: ["料理"],
        description: "家庭料理の基本レシピ",
        cover: "/images/no_image.png",
        draft: false,
        markdown: markdown2
      ),
      build(
        :entry,
        id: "entry_003",
        title: "東京観光ガイド",
        date: Time.new(2026, 1, 20, 15, 0, 0),
        permalink: "/entries/tokyo_travel_guide",
        categories: ["旅行"],
        description: "東京旅行の定番スポット紹介",
        cover: "/images/no_image.png",
        draft: false,
        markdown: markdown3
      ),
      build(
        :entry,
        id: "entry_004",
        title: "料理レシピ: カレー",
        date: Time.new(2026, 1, 21, 12, 0, 0),
        permalink: "/entries/curry_recipe",
        categories: ["料理"],
        description: "家庭で作れるカレー",
        cover: "/images/no_image.png",
        draft: false,
        markdown: markdown4
      ),
      build(
        :entry,
        id: "entry_005",
        title: "料理レシピ: かんたんパスタ",
        date: Time.new(2026, 1, 21, 12, 0, 0),
        permalink: "/entries/pasta_recipe",
        categories: ["料理"],
        description: "時短かんたんパスタ",
        cover: "/images/no_image.png",
        draft: false,
        markdown: markdown5
      )
    ]
  end

  it "類似エントリを設定する" do
    described_class.run(entries)

    expect(entries[0]).to respond_to(:similarities)
    expect(entries[0].similarities.size).to eq(1)
    expect(entries[0].similarities.first.id).to eq("entry_003")
    expect(entries[0].similarities.first.cover).to eq("/images/no_image.png")

    expect(entries[1]).to respond_to(:similarities)
    expect(entries[1].similarities.size).to eq(2)
    expect(entries[1].similarities.map(&:id)).to contain_exactly("entry_004", "entry_005")

    expect(entries[2]).to respond_to(:similarities)
    expect(entries[2].similarities.size).to eq(1)
    expect(entries[2].similarities.first.id).to eq("entry_001")

    expect(entries[3]).to respond_to(:similarities)
    expect(entries[3].similarities.size).to eq(2)
    expect(entries[3].similarities.map(&:id)).to contain_exactly("entry_002", "entry_005")

    expect(entries[4]).to respond_to(:similarities)
    expect(entries[4].similarities.size).to eq(2)
    expect(entries[4].similarities.map(&:id)).to contain_exactly("entry_004", "entry_002")
  end

  context "indexがfalseのエントリが含まれる場合" do
    let(:hidden) do
      build(:entry, id: "hidden", title: entries[0].title, markdown: entries[0].markdown, permalink: "/hidden.html", index: false)
    end

    it "対象にしない" do
      all = [hidden, *entries]
      described_class.run(all)

      expect(all[0]).to equal(hidden)
      expect(all[0]).not_to respond_to(:similarities)
      expect(all.drop(1).flat_map {|entry| entry.similarities.map(&:id) }).not_to include("hidden")
    end
  end

  context "類似するエントリがない場合" do
    before do
      indexer = Simpress::Plugin::Similarity::Indexer.new(entries)
      allow(indexer).to receive(:each_similarity) {|&block| entries.size.times {|i| block.call([], i) } }
      allow(Simpress::Plugin::Similarity::Indexer).to receive(:new).and_return(indexer)
    end

    it "similaritiesが空になる" do
      described_class.run(entries)
      entries.each {|entry| expect(entry.similarities).to be_empty }
    end
  end

  context "modeがjsonの場合" do
    before do
      allow(Simpress::Config).to receive(:mode).and_return("json")
    end

    context "keysにcontentを含む場合" do
      it "similaritiesを含む" do
        described_class.run(entries)

        expect(entries[0].to_h(keys: [:title, :content])).to include(:similarities)
      end
    end

    context "keysにcontentを含まない場合" do
      it "similaritiesを含まない" do
        described_class.run(entries)

        expect(entries[0].to_h(keys: [:title])).not_to include(:similarities)
      end
    end
  end
end
