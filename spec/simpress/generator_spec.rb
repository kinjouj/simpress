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
    allow(Simpress::Generator::Renderer).to receive(:generate)
    allow(Simpress::Theme).to receive(:clear)
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

    it "executes the generation pipeline in the correct order" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process).ordered
      expect(Simpress::Generator::Renderer).to have_received(:generate).ordered
      expect(Simpress::Theme).to have_received(:clear).ordered
    end
  end

  describe ".build_backlinks" do
    let(:post_a) { build(:post, permalink: "/post-a.html", title: "Post A", links: ["/post-b.html", "/post-c.html"]) }
    let(:post_b) { build(:post, permalink: "/post-b.html", title: "Post B", links: ["/post-a.html"]) }
    let(:post_c) { build(:post, permalink: "/post-c.html", title: "Post C", links: []) }

    before { described_class.send(:build_backlinks, [post_a, post_b, post_c]) }

    it "sets inbound links correctly" do
      expect(post_a.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/post-b.html", "Post B"])
      expect(post_b.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/post-a.html", "Post A"])
      expect(post_c.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/post-a.html", "Post A"])
    end

    it "ignores links not matching any post permalink" do
      post = build(:post, permalink: "/post-x.html", links: ["https://example.com"])
      described_class.send(:build_backlinks, [post])
      expect(post.backlinks).to be_empty
    end
  end
end
