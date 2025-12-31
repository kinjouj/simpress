# frozen_string_literal: true

require "simpress/generator/json/permalink_renderer"

describe Simpress::Generator::Json::PermalinkRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write)
  end

  let(:post) do
    build_post_data(1)
  end

  it "test" do
    expect { described_class.generate(post) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write).with("/post1.json", post.to_json(include_content: true))
  end
end
