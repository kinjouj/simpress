# frozen_string_literal: true

require "simpress/category"
require "simpress/generator/renderer/category_index_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::CategoryIndexRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield(anything)
  end

  let(:category) { Simpress::Category.fetch("Ruby") }
  let(:post1) { build(:post, id: 1, categories: [category]) }
  let(:post2) { build(:post, id: 2, categories: [category]) }
  let(:category_posts) { { category => [post1, post2] } }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("category index")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(category_posts)
      expect(Simpress::Writer).to have_received(:write).with("/archives/category/ruby/index.html", "category index")
      expect(Simpress::Logger).to have_received(:info)
      expect(Simpress::Theme).to have_received(:render)
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(category_posts)
      expect(Simpress::Writer).to have_received(:write).with(
        "/archives/category/ruby.json",
        Simpress::JSON.dump(category_posts[category], keys: keys)
      )
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
