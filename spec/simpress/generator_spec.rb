# frozen_string_literal: true

require "simpress/generator"

describe Simpress::Generator do
  let(:draft_post) { build(:post, draft: true) }
  let(:post1) { build(:post, date: Time.new(2025, 1, 1)) }
  let(:post2) { build(:post, date: Time.new(2025, 6, 1)) }
  let(:page) { build(:post, index: false) }

  before do
    allow(Dir).to receive(:glob).and_yield("draft.markdown")
                                .and_yield("post1.markdown")
                                .and_yield("post2.markdown")
                                .and_yield("page.markdown")
    allow(Simpress::Parser).to receive(:parse).with("draft.markdown").and_return(draft_post)
    allow(Simpress::Parser).to receive(:parse).with("post1.markdown").and_return(post1)
    allow(Simpress::Parser).to receive(:parse).with("post2.markdown").and_return(post2)
    allow(Simpress::Parser).to receive(:parse).with("page.markdown").and_return(page)
    allow(Simpress::Plugin).to receive(:process)
    allow(Simpress::Generator::Pipeline).to receive(:generate)
    allow(Simpress::Theme).to receive(:clear)
  end

  after { described_class.clear }

  describe ".clear" do
    it "resets link_index to nil" do
      described_class.send(:build_post_relations!, [build(:post)])
      expect(described_class.link_index).not_to be_nil
      described_class.clear
      expect(described_class.link_index).to be_nil
    end
  end

  describe ".each_file" do
    it "raises when called without a block" do
      expect { described_class.each_file }.to raise_error(ArgumentError)
    end

    it "yields each markdown file path found under source_dir" do
      allow(Dir).to receive(:glob).and_yield("post1.markdown").and_yield("post2.markdown")
      yielded = []
      described_class.each_file {|file| yielded << file }
      expect(Dir).to have_received(:glob).with("source/**/*.markdown")
      expect(yielded).to eq ["post1.markdown", "post2.markdown"]
    end
  end

  describe ".generate" do
    it "globs markdown files under source_dir" do
      described_class.generate
      expect(Dir).to have_received(:glob).with("source/**/*.markdown")
    end

    it "skips draft posts" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process) do |posts, pages|
        expect(posts + pages).not_to include(draft_post)
      end
    end

    it "separates posts and pages based on index attribute" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process) do |posts, pages|
        expect(posts).to contain_exactly(post1, post2)
        expect(pages).to contain_exactly(page)
      end
    end

    it "sorts posts by timestamp descending" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process) do |posts, _pages|
        expect(posts).to eq([post2, post1])
      end
    end

    it "loads pages as well as posts, since pages are not covered by build_post_relations!" do
      allow(page).to receive(:load!).and_call_original
      described_class.generate
      expect(page).to have_received(:load!)
    end

    it "executes the generation pipeline in the correct order" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process).ordered
      expect(Simpress::Generator::Pipeline).to have_received(:generate).ordered
      expect(Simpress::Theme).to have_received(:clear).ordered
    end
  end

  describe ".build_post_relations!" do
    let(:post_a) { build(:post, permalink: "/post-a.html", title: "Post A", markdown: "[b](/post-b.html) [c](/post-c.html)") }
    let(:post_b) { build(:post, permalink: "/post-b.html", title: "Post B", markdown: "[a](/post-a.html)") }
    let(:post_c) { build(:post, permalink: "/post-c.html", title: "Post C", markdown: "no links here") }

    before { described_class.send(:build_post_relations!, [post_a, post_b, post_c]) }

    it "sets inbound links correctly" do
      expect(post_a.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/post-b.html", "Post B"])
      expect(post_b.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/post-a.html", "Post A"])
      expect(post_c.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/post-a.html", "Post A"])
    end

    it "ignores links not matching any post permalink" do
      post = build(:post, permalink: "/post-x.html", markdown: "[external](https://example.com)")
      described_class.send(:build_post_relations!, [post])
      expect(post.backlinks).to be_empty
    end

    it "assigns next to the newer post and prev to the older post" do
      expect(post_a.prev.permalink).to eq "/post-b.html"
      expect(post_a.next).to be_nil
      expect(post_b.prev.permalink).to eq "/post-c.html"
      expect(post_b.next.permalink).to eq "/post-a.html"
      expect(post_c.prev).to be_nil
      expect(post_c.next.permalink).to eq "/post-b.html"
    end

    it "freezes each post" do
      expect(post_a).to be_frozen
      expect(post_b).to be_frozen
      expect(post_c).to be_frozen
    end
  end
end
