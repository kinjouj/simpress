# frozen_string_literal: true

require "simpress/generator/renderer"
require "simpress/post"

describe Simpress::Generator::Renderer do
  let(:post1) { build(:post, date: Time.new(2026, 1, 15)) }
  let(:post2) { build(:post, date: Time.new(2026, 1, 10)) }
  let(:posts) { [post1, post2] }
  let(:pages) { [build(:post, layout: "page")] }
  let(:taxonomy) { Simpress::Taxonomy.fetch("categories") }

  before do
    allow(Simpress::Taxonomy).to receive(:taxonomies).and_return([taxonomy])
    allow(Simpress::Generator::Renderer::Permalink).to receive(:generate)
    allow(Simpress::Generator::Renderer::Page).to receive(:generate)
    allow(Simpress::Generator::Renderer::Archive::PostIndex).to receive(:generate)
    allow(Simpress::Generator::Renderer::Archive::Monthly).to receive(:generate)
    allow(Simpress::Generator::Renderer::Archive::Taxonomy).to receive(:generate)
  end

  after do
    Simpress::Taxonomy.clear
  end

  describe ".generate" do
    it "calls PermalinkRenderer.generate for each post" do
      described_class.generate(posts, pages)
      expect(Simpress::Generator::Renderer::Permalink).to have_received(:generate).with(post1)
      expect(Simpress::Generator::Renderer::Permalink).to have_received(:generate).with(post2)
    end

    it "assigns next to the newer post and prev to the older post" do
      described_class.generate(posts, pages)
      newer, older = posts
      expect(newer.adjacent.prev).to eq Simpress::Post::Adjacent.summarize(older)
      expect(newer.adjacent.next).to be_nil
      expect(older.adjacent.next).to eq Simpress::Post::Adjacent.summarize(newer)
      expect(older.adjacent.prev).to be_nil
    end

    it "calls Monthly.generate with grouped posts by month" do
      described_class.generate(posts, pages)
      expected_archives = { Time.new(2026, 1, 1) => [post1, post2] }
      expect(Simpress::Generator::Renderer::Archive::Monthly).to have_received(:generate).with(expected_archives)
    end

    it "calls other renderers with correct arguments" do
      described_class.generate(posts, pages)
      expect(Simpress::Generator::Renderer::Page).to have_received(:generate).with(pages)
      expect(Simpress::Generator::Renderer::Archive::PostIndex).to have_received(:generate).with(posts)
      expect(Simpress::Generator::Renderer::Archive::Taxonomy).to have_received(:generate).with([taxonomy])
    end
  end
end
