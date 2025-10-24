# frozen_string_literal: true

require "simpress/config"
require "simpress/logger"
require "simpress/markdown/filter"
require "simpress/parser/redcarpet/renderer"

describe Simpress::Parser::Redcarpet::Renderer do
  after do
    Simpress::Markdown::Filter.clear
  end

  context "メソッドのテスト" do
    let(:renderer) { described_class.new }

    it "#paragraph" do
      expect(renderer.paragraph("test")).to eq("<p>test</p>")
    end

    it "#header" do
      expect(renderer.header("test", 4)).to eq("<h4>test</h4>")
      expect(renderer.toc).to eq(["test"])
      expect(renderer.header("test2", 3)).to eq("<h3>test2</h3>")
      expect(renderer.toc).to eq(["test"])
      expect(renderer.header("test3", 4)).to eq("<h4>test3</h4>")
      expect(renderer.toc).to eq(%w[test test3])
    end

    it "#image" do
      expect(renderer.image("/test.jpg")).to eq(%(<img src="/test.jpg" class="img-fluid" alt="image" />))
      expect(renderer.primary_image).to eq("/test.jpg")
      renderer.image("/test2.jpg")
      expect(renderer.primary_image).to eq("/test.jpg")
    end

    it "#autolink" do
      expect(renderer.autolink("/test")).to start_with(%(<a href="/test"))
    end

    it "#block_code" do
      expect(
        renderer.block_code("<test>", "test-lang")
      ).to eq(%(<pre class="line-numbers"><code class="language-test-lang">&lt;test&gt;</code></pre>))
    end

    it "#preprocess" do
      test_filter = Class.new do
        extend Simpress::Markdown::Filter

        def self.preprocess(data)
          data.upcase
        end
      end

      stub_const("TestFilter", test_filter)
      markdown = renderer.preprocess(fixture("parser/redcarpet/parser_redcarpet_test.markdown").read)
      expect(markdown).not_to be_nil
      expect(markdown).to start_with("#### TEST1")
    end
  end
end
