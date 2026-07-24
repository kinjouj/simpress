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

    it "integrates with real taxonomy terms without registering itself yet" do
      post = described_class.new(params)
      category_terms = post.taxonomies["categories"]
      expect(category_terms.size).to eq 1
      expect(category_terms.first.name).to eq "Ruby"
      expect(category_terms.first.posts).not_to include(post)
    end

    it "defaults prev to nil" do
      post = described_class.new(params)
      expect(post.prev).to be_nil
    end

    it "defaults next to nil" do
      post = described_class.new(params)
      expect(post.next).to be_nil
    end
  end

  describe "#register_taxonomies!" do
    it "registers itself to each resolved taxonomy term" do
      post = described_class.new(params)
      post.register_taxonomies!
      expect(post.taxonomies["categories"].first.posts).to include(post)
    end

    context "when the post is a draft" do
      let(:params) { super().merge(draft: true) }

      it "does not register itself to any taxonomy term" do
        post = described_class.new(params)
        post.register_taxonomies!
        expect(post.taxonomies["categories"].first.posts).not_to include(post)
      end
    end
  end

  describe "#set_adjacent!" do
    let(:newer_post) { described_class.new(id: "post-456", title: "Newer Post", permalink: "/newer-post") }
    let(:older_post) { described_class.new(id: "post-789", title: "Older Post", permalink: "/older-post") }

    it "assigns prev from the older post summary" do
      post = described_class.new(params)
      post.set_adjacent!(newer_post, older_post)
      expect(post.prev).to eq described_class::PostLink.new(id: "post-789", title: "Older Post", permalink: "/older-post")
    end

    it "assigns next from the newer post summary" do
      post = described_class.new(params)
      post.set_adjacent!(newer_post, older_post)
      expect(post.next).to eq described_class::PostLink.new(id: "post-456", title: "Newer Post", permalink: "/newer-post")
    end

    it "assigns nil prev when older_post is nil" do
      post = described_class.new(params)
      post.set_adjacent!(newer_post, nil)
      expect(post.prev).to be_nil
    end

    it "assigns nil next when newer_post is nil" do
      post = described_class.new(params)
      post.set_adjacent!(nil, older_post)
      expect(post.next).to be_nil
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

    it "includes the assigned prev and next" do
      newer_post = described_class.new(id: "post-456", title: "Newer Post", permalink: "/newer-post")
      older_post = described_class.new(id: "post-789", title: "Older Post", permalink: "/older-post")
      post = described_class.new(params)
      post.set_adjacent!(newer_post, older_post)
      result = post.to_h
      expect(result[:prev]).to eq post.prev
      expect(result[:next]).to eq post.next
    end

    it "includes nil prev and next by default" do
      post = described_class.new(params)
      result = post.to_h
      expect(result[:prev]).to be_nil
      expect(result[:next]).to be_nil
    end
  end

  describe "#as_json" do
    it "returns the same hash as #to_h" do
      post = described_class.new(params)
      expect(post.as_json).to eq post.to_h
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
