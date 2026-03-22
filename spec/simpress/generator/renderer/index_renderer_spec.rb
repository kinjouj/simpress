# frozen_string_literal: true

require "simpress/generator/renderer/index_renderer"
require "simpress/paginator"
require "simpress/post"

describe Simpress::Generator::Renderer::IndexRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield(anything)
  end

  let(:paginator) { Simpress::Paginator.new(1, 1) }
  let(:post1) { build(:post, id: 1, date: Time.new(2025, 11, 1)) }
  let(:post2) { build(:post, id: 2, date: Time.new(2025, 11, 2)) }
  let(:posts) { [post1, post2] }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("hoge")
    end

    it "正常に.generate_indexが実行されること" do
      described_class.generate_html(posts, paginator)
      expect(Simpress::Writer).to have_received(:write).with("/index.html", "hoge")
      expect(Simpress::Logger).to have_received(:info)
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }
    let(:expected_json) { Simpress::JSON.dump(posts, keys: keys) }

    it "正常にgenerate_jsonメソッドが実行されること" do
      described_class.generate_json(posts, paginator)
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", expected_json)
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
