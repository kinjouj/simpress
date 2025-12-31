# frozen_string_literal: true

require "simpress/generator"

describe Simpress::Generator do
  let(:category) { Simpress::Model::Category.new("Test") }
  let(:post1) { build_post_data(1, categories: [category]) }
  let(:post2) { build_post_data(2, categories: [category]) }
  let(:post3) { build_post_data(3, published: false) }
  let(:page) { build_post_data(4, layout: :page) }

  before do
    allow(Dir).to receive(:[]).and_return(["post1.md", "post2.md", "post3.md", "page1.md"])
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Plugin).to receive(:process)
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Parser).to receive(:parse).with("post1.md").and_return(post1)
    allow(Simpress::Parser).to receive(:parse).with("post2.md").and_return(post2)
    allow(Simpress::Parser).to receive(:parse).with("post3.md").and_return(post3)
    allow(Simpress::Parser).to receive(:parse).with("page1.md").and_return(page)
    allow(Simpress::Generator::Html).to receive(:generate)
  end

  it "test" do
    expect { described_class.generate }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).at_least(1).times
    expect(Simpress::Plugin).to have_received(:process).exactly(1).times
    expect(Simpress::Generator::Html).to have_received(:generate).with(
      [post1, post2],
      [page],
      hash_including("test" => category)
    )
  end
end
