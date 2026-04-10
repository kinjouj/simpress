# frozen_string_literal: true

require "simpress/post"
require "simpress/taxonomy"

describe Simpress::Post do
  let(:date) { Time.new(2026, 1, 1) }

  let(:params) do
    {
      id: "post-123",
      title: "Sample Post",
      date: date,
      permalink: "/sample-post",
      content: "Main content here",
      description: "Short description",
      toc: "Table of contents",
      cover: "cover.png",
      layout: "default",
      index: true,
      draft: false,
      markdown: true,
      categories: ["Ruby"]
    }
  end

  before do
    allow(Simpress::Config.instance).to receive(:taxonomies).and_return({ "categories" => { "Ruby" => "ruby" } })
  end

  after do
    Simpress::Taxonomy.clear
  end

  describe "#initialize" do
    it "assigns properties" do
      post = described_class.new(params)
      expect(post.id).to eq "post-123"
      expect(post.title).to eq "Sample Post"
      expect(post.date).to eq date
      expect(post.permalink).to eq "/sample-post"
    end

    it "integrates with real taxonomy terms and registers itself to them" do
      post = described_class.new(params)
      category_terms = post.taxonomies["categories"]
      expect(category_terms.size).to eq 1
      expect(category_terms.first.name).to eq "Ruby"
      expect(category_terms.first.posts).to include(post)
    end
  end

  describe "#timestamp" do
    it "returns the integer unix timestamp" do
      expect(described_class.new(params).timestamp).to eq date.to_i
    end
  end

  describe "#to_h" do
    it "returns a hash containing only permitted json keys" do
      post = described_class.new(params)
      result = post.to_h
      expect(result.keys).to match_array(described_class::PERMITTED_JSON_KEYS)
      expect(result[:id]).to eq "post-123"
    end

    it "filters keys when specific keys are requested" do
      post = described_class.new(params)
      result = post.to_h(keys: [:title, :permalink])
      expect(result.keys).to contain_exactly(:title, :permalink)
    end
  end

  describe "#to_json" do
    let(:json_output) { '{"id":"post-123"}' }

    it "dumps the hash using Simpress::JSON" do
      post = described_class.new(params)
      allow(Simpress::JSON).to receive(:dump).and_return(json_output)
      result = post.to_json
      expect(Simpress::JSON).to have_received(:dump).with(post.as_json)
      expect(result).to eq json_output
    end
  end
end
