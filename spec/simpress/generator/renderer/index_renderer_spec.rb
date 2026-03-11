# frozen_string_literal: true

require "simpress/generator/renderer/index_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::IndexRenderer do
  before do
    allow(Simpress::Writer).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:post1) { build(:post, id: 1, date: Time.new(2025, 11, 1)) }
  let(:post2) { build(:post, id: 2, date: Time.new(2025, 11, 2)) }
  let(:posts) { [post1, post2] }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("index")
    end

    let(:paginator) { Simpress::Paginator.builder.index(2).build }

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(posts, paginator)
      expect(Simpress::Writer).to have_received(:write).with("/index.html", "index")
      expect(Simpress::Logger).to have_received(:info)
      expect(Simpress::Theme).to have_received(:render)
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }
    let(:expected_json) { Simpress::JSON.dump(posts, keys: keys) }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(posts, 1)
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", expected_json)
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
