# frozen_string_literal: true

require "simpress/generator/renderer/permalink_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::PermalinkRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield("public/test1.html")
  end

  let(:post1) { build(:post) }

  describe ".generate_html" do
    before do
      allow(File).to receive(:utime)
      allow(Simpress::Theme).to receive(:render).and_return("test")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(post1)
      expect(Simpress::Writer).to have_received(:write).with("/test1.html", "test")
      expect(File).to have_received(:utime).with(post1.date, post1.date, "public/test1.html")
      expect(Simpress::Logger).to have_received(:info)
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(post1)
      expect(Simpress::Writer).to have_received(:write).with("/test1.json", post1.to_json(keys: keys))
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
