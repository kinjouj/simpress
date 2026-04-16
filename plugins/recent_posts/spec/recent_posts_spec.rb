# frozen_string_literal: true

require "simpress/plugin/recent_posts"
require "simpress/post"

describe Simpress::Plugin::RecentPosts do
  let(:posts) do
    Array.new(10) do |i|
      Simpress::Post.new(id: "post-#{i}", title: "Title #{i}", permalink: "/post-#{i}")
    end
  end

  before do
    allow(described_class).to receive(:bind_context)
    allow(Simpress::Config.instance).to receive(:mode)
    allow(Simpress::Writer).to receive(:write)
    allow(Simpress::JSON).to receive(:dump).and_return('{"json": true}')
  end

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
      end

      it "binds only the first 5 posts to the context" do
        described_class.run(posts)
        expect(described_class).to have_received(:bind_context).with(recent_posts: posts.take(5))
      end

      it "handles fewer than 5 posts" do
        small_posts = posts.take(2)
        described_class.run(small_posts)
        expect(described_class).to have_received(:bind_context).with(recent_posts: small_posts)
      end

      it "handles nil posts input" do
        described_class.run(nil)
        expect(described_class).to have_received(:bind_context).with(recent_posts: [])
      end
    end

    context "when mode is json" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      end

      it "writes the first 5 posts to recent_posts.json" do
        described_class.run(posts)

        expect(Simpress::JSON).to have_received(:dump).with(posts.take(5), keys: [:title, :permalink])
        expect(Simpress::Writer).to have_received(:write).with("recent_posts.json", '{"json": true}')
      end
    end

    context "when mode is unknown" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("xml")
      end

      it "raises an error" do
        expect { described_class.run(posts) }.to raise_error("Error")
      end
    end
  end
end
