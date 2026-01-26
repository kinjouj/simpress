# frozen_string_literal: true

require "simpress/plugin/similarity"

describe Simpress::Plugin::Similarity do
  let(:post1) { load_fixture("data1.yaml") }
  let(:post2) { load_fixture("data2.yaml") }
  let(:post3) { load_fixture("data3.yaml") }
  let(:post4) { load_fixture("data4.yaml") }
  let(:post5) { load_fixture("data5.yaml") }
  let(:posts) { [post1, post2, post3, post4, post5] }

  it "相関データが正しくファイルとして出力されること" do
    expect { described_class.run(posts) }.not_to raise_error

    expect(post1.similarities.size).to eq(1)
    expect(post1.similarities.first[:id]).to eq("post_003")
    expect(post1.as_json).to match(hash_including(similarities: post1.similarities))

    expect(post2.similarities.size).to eq(2)
    expect(post2.similarities.map { _1[:id] }).to eq(%w[post_004 post_005])

    expect(post3.similarities.size).to eq(1)
    expect(post3.similarities.first[:id]).to eq("post_001")

    expect(post4.similarities.size).to eq(2)
    expect(post4.similarities.map { _1[:id] }).to eq(%w[post_002 post_005])

    expect(post5.similarities.size).to eq(2)
    expect(post5.similarities.map { _1[:id] }).to eq(%w[post_004 post_002])
  end

  context "cosineが0を出した場合" do
    before do
      cosine_similarities = Simpress::Plugin::Similarity::CosineSimilarity.new(posts)
      allow(cosine_similarities).to receive(:cosine).and_return(0)
      allow(Simpress::Plugin::Similarity::CosineSimilarity).to receive(:new).and_return(cosine_similarities)
    end

    it do
      expect { described_class.run(posts) }.not_to raise_error
      posts.each {|post| expect(post.similarities).to be_empty }
    end
  end
end
