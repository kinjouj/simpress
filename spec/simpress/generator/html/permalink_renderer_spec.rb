# frozen_string_literal: true

require "simpress/model/post"
require "simpress/generator/html/permalink_renderer"

describe Simpress::Generator::Html::PermalinkRenderer do
  before do
    allow(FileUtils).to receive(:touch)
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Theme).to receive(:render).and_return("test")
    allow(Simpress::Writer).to receive(:write).and_yield("public/test.html")
  end

  let(:post1) do
    build_post_data(1)
  end

  it "test" do
    expect { described_class.generate(1, post1) }.not_to raise_error
    expect(FileUtils).to have_received(:touch).with("public/test.html", mtime: post1.date.to_time)
    expect(Simpress::Logger).to have_received(:info)
    expect(Simpress::Writer).to have_received(:write).with("/post1.html", "test")
  end
end
