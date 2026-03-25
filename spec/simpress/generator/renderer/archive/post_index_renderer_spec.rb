# frozen_string_literal: true

require "simpress/generator/renderer/archive/post_index_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::Archive::PostIndexRenderer do
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
      described_class.generate_html(posts)
      expect(Simpress::Writer).to have_received(:write).with("/index.html", "hoge")
      expect(Simpress::Logger).to have_received(:info)
    end
  end

  describe ".generate_json" do
    before do
      allow(Simpress::Config.instance).to receive(:paginate).and_return(1)
    end

    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが実行されること" do
      described_class.generate_json(posts)
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", Simpress::JSON.dump([post1], keys: keys))
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/2.json", Simpress::JSON.dump([post2], keys: keys))
      expect(Simpress::Writer).to have_received(:write).with("/archives/page/meta.json", anything)
      expect(Simpress::Logger).to have_received(:info).exactly(3)
    end
  end
end
