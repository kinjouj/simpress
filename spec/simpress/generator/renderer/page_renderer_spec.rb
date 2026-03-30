# frozen_string_literal: true

require "simpress/generator/renderer/page_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::PageRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield(anything)
  end

  let(:post1) { build(:post, index: false) }
  let(:post2) { build(:post, index: false) }
  let(:pages) { [post1, post2] }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("test")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(pages)
      expect(Simpress::Writer).to have_received(:write).exactly(2).times
      expect(Simpress::Writer).to have_received(:write).with("/page/test1.html", "test")
      expect(Simpress::Writer).to have_received(:write).with("/page/test2.html", "test")
      expect(Simpress::Logger).to have_received(:info).exactly(2).times
      expect(Simpress::Theme).to have_received(:render).exactly(2).times
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(pages)
      expect(Simpress::Writer).to have_received(:write).exactly(2).times
      expect(Simpress::Writer).to have_received(:write).with("/page/test1.json", post1.to_json(keys: keys))
      expect(Simpress::Writer).to have_received(:write).with("/page/test2.json", post2.to_json(keys: keys))
      expect(Simpress::Logger).to have_received(:info).exactly(2).times
    end
  end
end
