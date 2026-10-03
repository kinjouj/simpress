# frozen_string_literal: true
# @plugins/similarity/lib/simpress/plugin/similarity.rb

require "simpress/entry"
require "simpress/plugin/similarity"

describe Simpress::Plugin::Similarity do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:binwrite)
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Plugin.clear
  end

  let(:entry1) do
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
      markdown: "## 浅草寺\n浅草寺は東京の有名寺院です。\n## 東京タワー\n東京タワーも観光名所です。"
    )
  end

  let(:entry2) do
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
      markdown: "## 材料\n鶏肉, 玉ねぎ, にんじん\n## 作り方\n1. 切る\n2. 炒める\n3. 煮る"
    )
  end

  let(:entry3) do
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
      markdown: "## 浅草寺\n浅草寺は有名な観光スポットです。\n## 上野公園\n上野公園も東京の名所です。"
    )
  end

  let(:entry4) do
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
      markdown: "## 材料\n鶏肉, 玉ねぎ, ...\n## 作り方\n1. 切る\n2. 炒める\n3. 煮る"
    )
  end

  let(:entry5) do
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
      markdown: "## 麺を茹でる\n## 麺を冷やす\n## 麺に和風ドレッシングをかける\n## 食べる\n## 終わり"
    )
  end

  let(:entries) { [entry1, entry2, entry3, entry4, entry5] }

  it "各エントリに正しい類似度データを割り当てる" do
    described_class.run(entries)

    expect(entries[0]).to respond_to(:similarities)
    expect(entries[0].similarities.size).to eq(1)
    expect(entries[0].similarities.first.id).to eq("entry_003")

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

  context "スコアが返されない場合" do
    let(:indexer) { Simpress::Plugin::Similarity::Indexer.new(entries) }

    before do
      allow(indexer).to receive(:each_similarity) {|&block| entries.size.times {|i| block.call([], i) } }
      allow(Simpress::Plugin::Similarity::Indexer).to receive(:new).and_return(indexer)
    end

    it "全てのエントリでsimilaritiesを空にする" do
      described_class.run(entries)
      entries.each {|entry| expect(entry.similarities).to be_empty }
    end
  end

  context "modeがjsonの場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
    end

    it "contentキーがある場合はto_hにsimilaritiesを含める" do
      described_class.run(entries)
      expect(entries[0].to_h(keys: [:title, :content])).to include(:similarities)
    end

    it "contentキーがない場合はto_hからsimilaritiesを除外する" do
      described_class.run(entries)
      expect(entries[0].to_h(keys: [:title])).not_to include(:similarities)
    end
  end
end
