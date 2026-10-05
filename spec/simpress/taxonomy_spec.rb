# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"

describe Simpress::Taxonomy do
  before do
    described_class.clear
    allow(Simpress::Config.instance).to receive(:taxonomies).and_return(
      { "types" => ["tags"], "aliases" => { "categories" => { "Ruby" => "ruby" } } }
    )
  end

  after do
    described_class.clear
  end

  describe ".fetch" do
    it "インスタンスを返す" do
      tags = described_class.fetch("tags")
      expect(tags).to be_a(described_class)
      expect(tags.name).to eq "tags"
      expect(tags).to equal(described_class.fetch("tags"))
    end
  end

  describe ".taxonomies" do
    it "デフォルトとyamlで定義されたタクソノミーを含む" do
      names = described_class.taxonomies.map(&:name)
      expect(names).to include("categories", "tags")
    end
  end

  describe ".resolve" do
    it "paramsに存在する各タクソノミーのtermを解決する" do
      params = { categories: ["Ruby"], tags: ["oss", "gem"] }
      result = described_class.resolve(params)

      expect(result.keys).to match_array(described_class.taxonomies.map(&:name))
      expect(result["categories"].map(&:name)).to eq ["Ruby"]
      expect(result["tags"].map(&:name)).to eq ["oss", "gem"]
    end

    it "paramsにないタクソノミーに対しては空配列を返す" do
      params = { categories: ["Ruby"] }
      result = described_class.resolve(params)

      expect(result["tags"]).to eq []
    end

    it "paramsに何もない場合は全てのタクソノミーに対して空配列を返す" do
      result = described_class.resolve({})

      expect(result.values).to all(eq [])
    end
  end

  describe ".register" do
    it "指定されたタクソノミーの各termにエントリを登録する" do
      entry = build(:entry, categories: ["Ruby"])
      described_class.register(entry.taxonomies, entry)
      expect(entry.taxonomies["categories"].first.entries).to include(entry)
    end
  end

  describe ".clear" do
    it "内部キャッシュとメモ化されたタクソノミーをリセットする" do
      obj = described_class.fetch("categories")
      described_class.clear
      expect(obj).not_to be(described_class.fetch("categories"))
    end
  end

  describe "#terms" do
    it "エントリが登録されているtermのみを返す" do
      taxonomy = described_class.fetch("categories")
      used = taxonomy.term("Ruby")
      taxonomy.term("Unused")
      used.entries << build(:entry)

      expect(taxonomy.terms).to eq({ "Ruby" => used })
    end
  end

  describe "#term" do
    it "指定された名前に対してslug上書きを使用したTermインスタンスを返し、タクソノミー内でメモ化する" do
      taxonomy = described_class.fetch("categories")
      term = taxonomy.term("Ruby")
      expect(term).to be_a(Simpress::Taxonomy::Term)
      expect(term.name).to eq "Ruby"
      expect(term.key).to eq "ruby"
      expect(taxonomy.term("Ruby")).to equal(term)
    end

    it "slugの上書きがない場合はto_urlにフォールバックする" do
      term = described_class.fetch("categories").term("Unknown")
      expect(term.key).to eq "unknown"
    end
  end
end
