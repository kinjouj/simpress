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
      description: "Short description",
      cover: "cover.png",
      layout: "default",
      index: true,
      draft: false,
      markdown: "Main content here",
      categories: ["Ruby"]
    }
  end

  let(:rendered_content) { "<p>Main content here</p>" }
  let(:render_result) do
    Simpress::Parser::Markdown::Processor::Result.new(
      content: rendered_content,
      toc: [{ id: "section-1", text: "Heading", children: [] }],
      links: ["/2026/01/other.html"],
      cover: "/images/extracted.png"
    )
  end

  before do
    allow(Simpress::Config.instance).to receive(:taxonomies).and_return({ "categories" => { "Ruby" => "ruby" } })
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(render_result)
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

    it "does not render the markdown body until #load! is called" do
      post = described_class.new(params)
      expect(Simpress::Parser::Markdown::Processor).not_to have_received(:render)
      expect(post.content).to be_nil
      expect(post.toc).to be_nil
      expect(post.links).to be_nil
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

  describe "#load!" do
    it "renders the markdown body and fills in content/toc/links/cover" do
      post = described_class.new(params)
      post.load!
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).with("Main content here")
      expect(post.content).to eq rendered_content
      expect(post.toc).to eq [{ id: "section-1", text: "Heading", children: [] }]
      expect(post.links).to eq ["/2026/01/other.html"]
    end

    it "does not re-render on subsequent calls" do
      post = described_class.new(params)
      post.load!
      post.load!
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).once
    end

    it "prefers the cover given in params over the one extracted from the body" do
      post = described_class.new(params)
      post.load!
      expect(post.cover).to eq "cover.png"
    end

    it "prefers the description given in params over the one extracted from the body" do
      post = described_class.new(params)
      post.load!
      expect(post.description).to eq "Short description"
    end

    context "when description is not given in params" do
      let(:params) { super().except(:description) }
      let(:rendered_content) { "<p>First paragraph.</p>\n<p>Second paragraph.</p>" }

      it "falls back to the text of the first paragraph in the rendered body" do
        post = described_class.new(params)
        post.load!
        expect(post.description).to eq "First paragraph."
      end
    end

    context "when description is not given in params and the first paragraph contains inline tags" do
      let(:params) { super().except(:description) }
      let(:rendered_content) { "<p>Hello <strong>world</strong>!</p>" }

      it "strips inline tags from the extracted description" do
        post = described_class.new(params)
        post.load!
        expect(post.description).to eq "Hello world!"
      end
    end

    context "when cover is not given in params" do
      let(:params) { super().except(:cover) }

      it "falls back to the image extracted from the body" do
        post = described_class.new(params)
        post.load!
        expect(post.cover).to eq "/images/extracted.png"
      end
    end

    context "when cover is not given in params and no image was extracted from the body" do
      let(:params) { super().except(:cover) }
      let(:render_result) do
        Simpress::Parser::Markdown::Processor::Result.new(content: rendered_content, toc: [], links: [], cover: nil)
      end

      it "falls back to the default cover" do
        post = described_class.new(params)
        post.load!
        expect(post.cover).to eq described_class::DEFAULT_COVER
      end
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

  describe "#prev and #next" do
    it "is nil by default and can be assigned" do
      post = described_class.new(params)
      expect(post.prev).to be_nil
      expect(post.next).to be_nil

      link = Simpress::Post::Link.new(post)
      post.prev = link
      post.next = link
      expect(post.prev).to eq link
      expect(post.next).to eq link
    end
  end

  describe "#to_h" do
    it "returns a hash containing only permitted json keys" do
      post = described_class.new(params)
      post.load!
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
      post.load!
      post.prev = Simpress::Post::Link.new(older_post)
      post.next = Simpress::Post::Link.new(newer_post)
      result = post.to_h
      expect(result[:prev]).to eq post.prev
      expect(result[:next]).to eq post.next
    end

    it "includes nil prev and next by default" do
      post = described_class.new(params)
      post.load!
      result = post.to_h
      expect(result[:prev]).to be_nil
      expect(result[:next]).to be_nil
    end
  end

  describe "#as_json" do
    it "returns the same hash as #to_h" do
      post = described_class.new(params)
      post.load!
      expect(post.as_json).to eq post.to_h
    end
  end

  describe "#to_json" do
    let(:json_output) { '{"id":"post-123"}' }

    it "dumps the hash using Simpress::JSON" do
      post = described_class.new(params)
      post.load!
      allow(Simpress::JSON).to receive(:dump).and_return(json_output)
      result = post.to_json
      expect(Simpress::JSON).to have_received(:dump).with(post.as_json)
      expect(result).to eq json_output
    end
  end
end
