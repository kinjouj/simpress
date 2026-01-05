# frozen_string_literal: true

require "simpress/category"
require "simpress/post"
require "simpress/generator/renderer/category_index_renderer"

describe Simpress::Generator::Renderer::CategoryIndexRenderer do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:category) { Simpress::Category.new("Ruby") }
  let(:post1) { build_post_data(1, categories: [category]) }
  let(:post2) { build_post_data(2, categories: [category]) }
  let(:category_posts) { { category => [post1, post2] } }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("category index")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      expect { described_class.generate_html(category_posts) }.not_to raise_error
      expect(File).to have_received(:write).with("public/archives/category/ruby/index.html", "category index")
      expect(Simpress::Logger).to have_received(:info)
      expect(Simpress::Theme).to have_received(:render)
    end
  end

  describe ".generate_json" do
    it "正常にgenerate_jsonメソッドが呼ばれること" do
      expect { described_class.generate_json(category_posts) }.not_to raise_error
      expect(File).to have_received(:write).with("public/archives/category/ruby.json", category_posts[category].to_json)
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
