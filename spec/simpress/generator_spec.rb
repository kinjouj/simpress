# frozen_string_literal: true

require "simpress/generator"

describe Simpress::Generator do
  let(:category) { Simpress::Category.fetch("Test") }
  let(:post1) { build_post_data(1, categories: [category], date: Time.new(2000, 1, 1)) }
  let(:post2) { build_post_data(2, categories: [category], date: Time.new(2000, 2, 1)) }
  let(:post3) { build_post_data(3, published: false) }
  let(:page) { build_post_data(4, layout: :page) }

  before do
    allow(Dir).to receive(:glob).and_yield("post1.md")
                                .and_yield("post2.md")
                                .and_yield("post3.md")
                                .and_yield("page1.md")
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Plugin).to receive(:process)
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Parser).to receive(:parse).with("post1.md").and_return(post1)
    allow(Simpress::Parser).to receive(:parse).with("post2.md").and_return(post2)
    allow(Simpress::Parser).to receive(:parse).with("post3.md").and_return(post3)
    allow(Simpress::Parser).to receive(:parse).with("page1.md").and_return(page)
    allow(Simpress::Generator::Html).to receive(:generate)
  end

  it "すべての投稿とページを正しく処理してHTML生成を呼び出すこと" do
    expect { described_class.generate }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).at_least(1).times
    expect(Simpress::Plugin).to have_received(:process).exactly(1).times
    expect(Simpress::Generator::Html).to have_received(:generate).with(
      [post2, post1],
      [page],
      hash_including(test: category)
    )
  end
end
