# frozen_string_literal: true

require "simpress/generator/html/index_renderer"

describe Simpress::Generator::Html::IndexRenderer do
  let(:post1) do
    build_post_data(1, date: DateTime.new(2025, 11, 15))
  end

  let(:post2) do
    build_post_data(2, date: DateTime.new(2025, 12, 1))
  end

  let(:posts) do
    [ post1, post2 ]
  end

  let(:paginator) do
    Simpress::Paginator.builder.maxpage(2).build
  end

  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Theme).to receive(:render).and_return("")
    allow(Simpress::Writer).to receive(:write)
  end

  it "test" do
    expect { described_class.generate(posts, paginator) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write)
  end
end
