# frozen_string_literal: true

require "simpress/generator"

describe Simpress::Generator do
  let(:category) { Simpress::Category.fetch("Test") }
  let(:post1) { build(:post, categories: [category], date: Time.new(2000, 1, 1)) }
  let(:post2) { build(:post, categories: [category], date: Time.new(2000, 2, 1)) }
  let(:post3) { build(:post, draft: true) }
  let(:page) { build(:post, layout: :page) }

  before do
    allow(Dir).to receive(:glob).and_yield("post1.md").and_yield("post2.md").and_yield("post3.md").and_yield("page1.md")
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Plugin).to receive(:process)
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
    allow(Simpress::Parser).to receive(:parse).with("post1.md").and_return(post1)
    allow(Simpress::Parser).to receive(:parse).with("post2.md").and_return(post2)
    allow(Simpress::Parser).to receive(:parse).with("post3.md").and_return(post3)
    allow(Simpress::Parser).to receive(:parse).with("page1.md").and_return(page)
    allow(Simpress::Generator::Renderer).to receive(:generate)
  end

  it "すべての投稿とページを正しく処理してHTML生成を呼び出すこと" do
    described_class.generate
    expect(Simpress::Plugin).to have_received(:process).exactly(1).times
    expect(Simpress::Generator::Renderer).to have_received(:generate).with(
      [post2, post1],
      [page],
      hash_including("test" => category)
    )
  end

  context "layoutが不正な値の場合" do
    let(:post4) { build(:post, layout: :test) }

    before do
      allow(Dir).to receive(:glob).and_yield("post.md")
      allow(Simpress::Parser).to receive(:parse).with("post.md").and_return(post4)
    end

    it "エラーが送出されること" do
      expect { described_class.generate }.to raise_error("Unknown layout test")
    end
  end
end
