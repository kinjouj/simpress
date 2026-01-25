# frozen_string_literal: true

require "simpress/plugin/similarity"

describe Simpress::Plugin::Similarity do
  before do
    allow(Simpress::Writer).to receive(:write)
  end

  let(:post1) { load_fixture("data1.yaml") }
  let(:post2) { load_fixture("data2.yaml") }
  let(:post3) { load_fixture("data3.yaml") }
  let(:post4) { load_fixture("data4.yaml") }
  let(:post5) { load_fixture("data5.yaml") }
  let(:posts) { [post1, post2, post3, post4, post5] }

  it "相関データが正しくファイルとして出力されること" do
    expect { described_class.run(posts) }.not_to raise_error
    expect(Simpress::Writer).to have_received(:write).exactly(5).times
    expect(Simpress::Writer).to have_received(:write).with("similarity/post_001.json", anything) do |_, data|
      json = JSON.parse(data, symbolize_names: true)
      similarity = json[:similarity]
      expect(similarity.size).to eq(1)
      expect(similarity.first[:id]).to eq("post_003")
    end
    expect(Simpress::Writer).to have_received(:write).with("similarity/post_002.json", anything) do |_, data|
      json = JSON.parse(data, symbolize_names: true)
      similarity = json[:similarity]
      expect(similarity.size).to eq(2)
      expect(similarity.map { _1[:id] }).to eq(["post_004", "post_005"])
    end
    expect(Simpress::Writer).to have_received(:write).with("similarity/post_003.json", anything) do |_, data|
      json = JSON.parse(data, symbolize_names: true)
      similarity = json[:similarity]
      expect(similarity.size).to eq(1)
      expect(similarity.first[:id]).to eq("post_001")
    end
    expect(Simpress::Writer).to have_received(:write).with("similarity/post_004.json", anything) do |_, data|
      json = JSON.parse(data, symbolize_names: true)
      similarity = json[:similarity]
      expect(similarity.size).to eq(2)
      expect(similarity.map { _1[:id] }).to eq(["post_002", "post_005"])
    end
    expect(Simpress::Writer).to have_received(:write).with("similarity/post_005.json", anything) do |_, data|
      json = JSON.parse(data, symbolize_names: true)
      similarity = json[:similarity]
      expect(similarity.size).to eq(2)
      expect(similarity.map { _1[:id] }).to eq(["post_004", "post_002"])
    end
  end

  context "cosineが0を出した場合" do
    before do
      cosine_similarity = Simpress::Plugin::Similarity::CosineSimilarity.new(posts)
      allow(cosine_similarity).to receive(:cosine).and_return(0)
      allow(Simpress::Plugin::Similarity::CosineSimilarity).to receive(:new).and_return(cosine_similarity)
    end

    it do
      expect { described_class.run(posts) }.not_to raise_error
      expect(Simpress::Writer).to have_received(:write).exactly(5).times
      expect(Simpress::Writer).to have_received(:write).exactly(5).with(anything, anything) do |_, data|
        json = JSON.parse(data, symbolize_names: true)
        expect(json[:similarity]).to be_empty
      end
    end
  end
end
