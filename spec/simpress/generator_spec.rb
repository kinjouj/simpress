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
end
