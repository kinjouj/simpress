# frozen_string_literal: true

require "simpress/parser/markdown/renderer"

describe Simpress::Parser::Markdown::Renderer do
  before do
    allow(Simpress::Logger).to receive(:debug)
  end

  after do
    Simpress::Parser::Markdown::Enhancer.clear
  end

  let(:renderer) { described_class.new }

  describe "#header" do
    before do
      renderer.reset!
    end

    it "ヘッダーを適切に生成し、tocを更新すること" do
      expect(renderer.header("test", 4)).to eq(%(<h4 id="section-1">test</h4>))
      expect(renderer.toc).to eq([["section-1", "test"]])

      expect(renderer.header("test3", 4)).to eq(%(<h4 id="section-2">test3</h4>))
      expect(renderer.toc).to eq([["section-1", "test"], ["section-2", "test3"]])
      renderer.reset!
    end

    it "<h4>以外の場合はデータが入らないこと" do
      expect(renderer.header("test2", 3)).to eq("<h3>test2</h3>")
      expect(renderer.toc).to be_empty
    end
  end

  describe "#image" do
    it "画像タグを生成し、primary_imageを設定すること" do
      expect(renderer.image("/test.jpg", nil, nil)).to eq(%(<img src="/test.jpg" alt="image" />))
      expect(renderer.primary_image).to eq("/test.jpg")
      renderer.image("/test2.jpg", nil, nil)
      expect(renderer.primary_image).to eq("/test.jpg")
    end
  end

  describe "#block_code" do
    it "コードブロックを適切に生成すること" do
      expect(
        renderer.block_code("<test>", "test-lang")
      ).to eq(%(<pre class="line-numbers"><code class="language-test-lang">&lt;test&gt;</code></pre>))
    end
  end

  describe "#preprocess" do
    it "フィルターを通したデータを返すこと" do
      test_filter = Class.new do
        extend Simpress::Parser::Markdown::Enhancer

        def self.preprocess(data)
          data.upcase
        end
      end

      markdown = <<~MARKDOWN
        #### TEST1

        ![](/test1.jpg)

        ![](/test2.jpg)

        ### TEST2
      MARKDOWN

      stub_const("TestFilter", test_filter)
      markdown = renderer.preprocess(markdown)
      expect(markdown).not_to be_nil
      expect(markdown).to start_with("#### TEST1")
      expect(Simpress::Logger).to have_received(:debug).exactly(1).times
    end
  end
end
