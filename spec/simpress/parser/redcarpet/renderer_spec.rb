# frozen_string_literal: true

require "simpress/config"
require "simpress/parser/redcarpet/filter"
require "simpress/parser/redcarpet/renderer"
require "simpress/logger"

describe Simpress::Parser::Redcarpet::Renderer do
  context "メソッドのテスト" do
    let(:renderer) { Simpress::Parser::Redcarpet::Renderer.new }

    it "#paragraph" do
      expect(renderer.paragraph("test")).to eq("<p>test</p>")
    end

    it "#header" do
      expect(renderer.header("test", 4)).to eq("<h4>test</h4>")
      expect(renderer.toc).to eq(["test"])
      expect(renderer.header("test2", 3)).to eq("<h4>test2</h4>")
      expect(renderer.toc).to eq(["test"])
      expect(renderer.header("test3", 4)).to eq("<h4>test3</h4>")
      expect(renderer.toc).to eq(%w[test test3])
    end

    it "#image and #images" do
      expect(renderer.image("/test.jpg")).to eq(%(<img src="/test.jpg" alt="image" />))
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
      expect(Simpress::Logger).to receive(:debug).once

      class TestFilter
        extend Simpress::Parser::Redcarpet::Filter

        def self.preprocess(data)
          data.upcase
        end
      end

      markdown = renderer.preprocess(fixture("parser_redcarpet_test.markdown").read)
      expect(markdown).not_to be_nil
      expect(markdown).to start_with("#### TEST1")
    end
  end
end
