# frozen_string_literal: true

require "simpress/generator/html/page_renderer"

describe Simpress::Generator::Html::PageRenderer do
  let(:post1) do
    build_post_data(1, date: DateTime.new(2025, 11, 15), layout: :page)
  end

  let(:post2) do
    build_post_data(2, date: DateTime.new(2025, 12, 1), layout: :page)
  end

  let(:pages) { [post1, post2] }

  before do
    allow(FileUtils).to receive(:touch)
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield("public/page.html")
  end

  it "test" do
    expect { described_class.generate(pages) }.not_to raise_error
    pages.each do |page|
      expect(FileUtils).to have_received(:touch).with("public/page.html", mtime: page.date.to_time)
      expect(Simpress::Writer).to have_received(:write).with(page.permalink, anything)
    end

    expect(Simpress::Logger).to have_received(:info).exactly(2).times
  end
end
