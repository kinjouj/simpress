# frozen_string_literal: true

require "simpress/parser/markdown/renderer"

describe Simpress::Parser::Markdown::Renderer do
  let(:renderer) do
    described_class.new
  end

  describe "#initialize" do
    it "空で初期化する" do
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc).to eq []
    end
  end

  describe "#link" do
    it "aタグを返す" do
      expect(renderer.link("/2026/01/entry.html", nil, "entry")).to eq '<a href="/2026/01/entry.html" target="_blank" rel="noopener">entry</a>'
      expect(renderer.link("https://example.com", nil, "example")).to eq '<a href="https://example.com" target="_blank" rel="noopener">example</a>'
    end
  end

  describe "#preprocess" do
    before do
      allow(Simpress::Parser::Markdown::Filter).to receive(:apply_preprocess).and_return("enhanced")
    end

    it "前処理した結果を返す" do
      markdown = "# Hello"
      result = renderer.preprocess(markdown)
      expect(Simpress::Parser::Markdown::Filter).to have_received(:apply_preprocess).with(markdown)
      expect(result).to eq "enhanced"
    end
  end

  describe "#postprocess" do
    before do
      allow(Simpress::Parser::Markdown::Filter).to receive(:apply_postprocess).and_return("processed")
    end

    it "後処理した結果を返す" do
      result = renderer.postprocess("<p>Hello</p>")
      expect(Simpress::Parser::Markdown::Filter).to have_received(:apply_postprocess).with("<p>Hello</p>")
      expect(result).to eq "processed"
    end
  end

  describe "#header" do
    it "レベル1ではh1タグを返す" do
      result = renderer.header("Title", 1)
      expect(result).to eq "<h1>Title</h1>"
      expect(renderer.toc).to be_empty
    end

    it "レベル2以上ではid付きの見出しを返す" do
      result = renderer.header("SubTitle", 2)
      expect(result).to eq '<h2 id="section-1">SubTitle</h2>'
      expect(renderer.toc.size).to eq 1

      heading = renderer.toc.first
      expect(heading[:id]).to eq "section-1"
      expect(heading[:text]).to eq "SubTitle"
      expect(heading[:children]).to eq []
    end

    it "レベル2をtocの最上位に入れる" do
      renderer.header("First", 2)
      renderer.header("Second", 2)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Second"]
    end

    it "レベル3以上をレベル2の子にする" do
      renderer.header("First", 2)
      result = renderer.header("Second", 3)

      expect(result).to include('id="section-2"')
      expect(renderer.toc.size).to eq 1
      first = renderer.toc.first
      expect(first[:text]).to eq "First"
      expect(first[:children]).to eq [{ id: "section-2", text: "Second" }]
    end

    it "連続する深い見出しを同じ子に並べる" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 4)

      expect(renderer.toc.first[:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
    end

    it "次のレベル2を新しい最上位にする" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 2)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Third"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second"]
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["Fourth"]
    end

    it "レベル2より前の深い見出しは最上位に入れる" do
      renderer.header("First", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First"]
    end

    it "最初の見出しの深さを最上位にする" do
      renderer.header("First", 3)
      renderer.header("Second", 4)
      renderer.header("Third", 4)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Fourth"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
      expect(renderer.toc[1][:children]).to eq []
    end

    it "浅い見出しを最上位にする" do
      renderer.header("A", 3)
      renderer.header("B", 2)
      renderer.header("C", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["A", "B"]
      expect(renderer.toc[0][:children]).to eq []
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["C"]
    end
  end

  describe "#image" do
    it "imgタグを返す" do
      result = renderer.image("first.png", nil, nil)
      expect(result).to eq '<img src="first.png" alt="image" />'
      expect(renderer.primary_image).to eq "first.png"
    end

    it "primary_imageを上書きしない" do
      renderer.image("first.png", nil, nil)
      renderer.image("second.png", nil, nil)
      expect(renderer.primary_image).to eq "first.png"
    end
  end

  describe "#block_code" do
    it "エスケープしたcodeブロックを返す" do
      code = 'puts "Hello" < & >'
      result = renderer.block_code(code, "ruby")
      expect(result).to include('class="language-ruby"')
      expect(result).to include("puts &quot;Hello&quot; &lt; &amp; &gt;")
    end

    it "langがnilならtextにする" do
      result = renderer.block_code("code", nil)
      expect(result).to include('class="language-text"')
    end
  end
end
