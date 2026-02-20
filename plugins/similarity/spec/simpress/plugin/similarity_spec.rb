# frozen_string_literal: true

require "simpress/plugin/similarity"

describe Simpress::Plugin::Similarity do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
  end

  let(:post1) { load_fixture("data1.yaml") }
  let(:post2) { load_fixture("data2.yaml") }
  let(:post3) { load_fixture("data3.yaml") }
  let(:post4) { load_fixture("data4.yaml") }
  let(:post5) { load_fixture("data5.yaml") }
  let(:posts) { [post1, post2, post3, post4, post5] }

  it "相関データが正しくファイルとして出力されること" do
    described_class.run(posts)

    expect(post1).to respond_to(:similarities)
    expect(post1.similarities.size).to eq(1)
    expect(post1.similarities.first[:id]).to eq("post_003")

    expect(post2).to respond_to(:similarities)
    expect(post2.similarities.size).to eq(2)
    expect(post2.similarities.map { _1[:id] }).to eq(["post_004", "post_005"])

    expect(post3).to respond_to(:similarities)
    expect(post3.similarities.size).to eq(1)
    expect(post3.similarities.first[:id]).to eq("post_001")

    expect(post4).to respond_to(:similarities)
    expect(post4.similarities.size).to eq(2)
    expect(post4.similarities.map { _1[:id] }).to eq(["post_002", "post_005"])

    expect(post5).to respond_to(:similarities)
    expect(post5.similarities.size).to eq(2)
    expect(post5.similarities.map { _1[:id] }).to eq(["post_004", "post_002"])
  end

  context "cosineが0を出した場合" do
    before do
      cosine_similarities = Simpress::Plugin::Similarity::CosineSimilarity.new(posts)
      allow(cosine_similarities).to receive(:cosine).and_return(0)
      allow(Simpress::Plugin::Similarity::CosineSimilarity).to receive(:new).and_return(cosine_similarities)
    end

    it "similaritiesが空になること" do
      described_class.run(posts)
      posts.each {|post| expect(post.similarities).to be_empty }
    end
  end

  context "modeがjsonの場合" do
    before do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
    end

    it "as_jsonでsimilaritiesが取得できること" do
      described_class.run(posts)
      expect(post1.as_json(keys: [:title, :content])).to include(:similarities)
    end
  end
end
