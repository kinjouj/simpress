# frozen_string_literal: true

require "simpress/generator/renderer/permalink_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::PermalinkRenderer do
  let(:post) { build(:post, title: "My Post", permalink: "my-post", layout: "page", date: Time.new(2026, 1, 1)) }

  before do
    allow(Simpress::Logger).to receive(:info)
  end

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write).and_yield("public/my-post.html")
      allow(File).to receive(:utime)
    end

    it "writes html for the post" do
      described_class.generate_html(post)
      expect(Simpress::Theme).to have_received(:render).with("page", post: post)
      expect(Simpress::Writer).to have_received(:write).with("my-post.html", "<html>content</html>")
      expect(File).to have_received(:utime).with(post.date, post.date, "public/my-post.html")
      expect(Simpress::Logger).to have_received(:info).with("[BUILD PAGE]: My Post public/my-post.html")
    end
  end

  describe ".generate_json" do
    let(:expected_post_json) { Simpress::JSON.dump(post, keys: described_class::DATA_JSON_KEYS) }

    before do
      allow(Simpress::Writer).to receive(:write).with(anything, expected_post_json).and_yield("public/my-post.json")
    end

    it "writes json with permitted keys" do
      described_class.generate_json(post)
      expect(Simpress::Writer).to have_received(:write).with(anything, expected_post_json)
      expect(Simpress::Logger).to have_received(:info).with("[BUILD PAGE]: My Post public/my-post.json")
    end
  end
end
