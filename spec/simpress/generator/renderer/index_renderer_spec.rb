# frozen_string_literal: true

require "simpress/category"
require "simpress/post"
require "simpress/generator/renderer/index_renderer"

describe Simpress::Generator::Renderer::IndexRenderer do
  before do
    allow(FileUtils).to receive(:mkdir_p)
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:post1) { build_post_data(1, date: Time.new(2025, 11, 1)) }
  let(:post2) { build_post_data(2, date: Time.new(2025, 11, 2)) }
  let(:posts) { [post1, post2] }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("index")
    end

    let(:paginator) { Simpress::Paginator.builder.maxpage(2).build }

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      expect { described_class.generate_html(posts, paginator) }.not_to raise_error
      expect(File).to have_received(:write).with("public/index.html", "index")
      expect(Simpress::Logger).to have_received(:info)
      expect(Simpress::Theme).to have_received(:render)
    end
  end

  describe ".generate_json" do
    it "正常にgenerate_jsonメソッドが呼ばれること" do
      expect { described_class.generate_json(posts, 1) }.not_to raise_error
      expect(File).to have_received(:write).with("public/archives/page/1.json", posts.to_json)
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
