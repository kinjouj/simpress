# frozen_string_literal: true

require "simpress/parser/markdown/renderer"

describe Simpress::Parser::Markdown::Renderer do
  let(:renderer) do
    described_class.new
  end

  describe "#initialize" do
    it "primary_image、toc、linksが空の状態で初期化される" do
      expect(renderer.primary_image).to be_nil
      expect(renderer.toc).to eq []
      expect(renderer.links).to eq []
    end
  end

  describe "#link" do
    it "/で始まる内部リンクを収集する" do
      renderer.link("/2026/01/entry.html", nil, "entry")
      expect(renderer.links).to eq ["/2026/01/entry.html"]
    end

    it "外部リンクは無視する" do
      renderer.link("https://example.com", nil, "example")
      expect(renderer.links).to be_empty
    end

    it "nilのURLは無視する" do
      renderer.link(nil, nil, "empty")
      expect(renderer.links).to be_empty
    end

    it "aタグを返す" do
      result = renderer.link("/2026/01/entry.html", nil, "entry")
      expect(result).to eq '<a href="/2026/01/entry.html" target="_blank" rel="noopener">entry</a>'
    end
  end

  describe "#preprocess" do
    before do
      allow(Simpress::Parser::Markdown::Filter).to receive(:preprocess).and_return("enhanced")
    end

    it "Simpress::Parser::Markdown::Filter.preprocessに委譲する" do
      markdown = "# Hello"
      result = renderer.preprocess(markdown)
      expect(Simpress::Parser::Markdown::Filter).to have_received(:preprocess).with(markdown)
      expect(result).to eq "enhanced"
    end
  end

  describe "#postprocess" do
    before do
      allow(Simpress::Parser::Markdown::Filter).to receive(:postprocess).and_return("processed")
    end

    it "Simpress::Parser::Markdown::Filter.postprocessに委譲する" do
      result = renderer.postprocess("<p>Hello</p>")
      expect(Simpress::Parser::Markdown::Filter).to have_received(:postprocess).with("<p>Hello</p>")
      expect(result).to eq "processed"
    end
  end

  describe "#header" do
    it "レベル1ではシンプルなh1タグを返す" do
      result = renderer.header("Title", 1)
      expect(result).to eq "<h1>Title</h1>"
      expect(renderer.toc).to be_empty
    end

    it "レベル2以上ではid付きの見出しを返しtocに登録する" do
      result = renderer.header("SubTitle", 2)
      expect(result).to eq '<h2 id="section-1">SubTitle</h2>'
      expect(renderer.toc.size).to eq 1

      heading = renderer.toc.first
      expect(heading[:id]).to eq "section-1"
      expect(heading[:text]).to eq "SubTitle"
      expect(heading[:children]).to eq []
    end

    it "セクションidをインクリメントする" do
      renderer.header("First", 2)
      result = renderer.header("Second", 3)
      expect(result).to include('id="section-2"')
    end

    it "レベル2の見出しをtocのトップレベルの項目として扱う" do
      renderer.header("First", 2)
      renderer.header("Second", 2)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Second"]
    end

    it "レベル3以上の見出しを直前のレベル2の見出しの子としてネストする" do
      renderer.header("First", 2)
      renderer.header("Second", 3)

      expect(renderer.toc.size).to eq 1
      first = renderer.toc.first
      expect(first[:text]).to eq "First"
      expect(first[:children].map {|heading| heading[:text] }).to eq ["Second"]
    end

    it "子レベルのノードにはchildrenキーを付与しない" do
      renderer.header("First", 2)
      renderer.header("Second", 3)

      child = renderer.toc.first[:children].first
      expect(child).to eq({ id: "section-2", text: "Second" })
    end

    it "連続する深い見出しはレベルに関係なく同じ子リストにフラット化する" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 4)

      expect(renderer.toc.first[:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
    end

    it "次のレベル2の見出しで子をリセットして新しいトップレベルのセクションを開始する" do
      renderer.header("First", 2)
      renderer.header("Second", 3)
      renderer.header("Third", 2)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Third"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second"]
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["Fourth"]
    end

    it "レベル2の見出しがまだ現れていない場合は深い見出しをトップレベルとして扱う" do
      renderer.header("First", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First"]
    end

    it "最初の見出しが2より深い場合はそれを基準にトップレベルを動的に決定する" do
      renderer.header("First", 3)
      renderer.header("Second", 4)
      renderer.header("Third", 4)
      renderer.header("Fourth", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["First", "Fourth"]
      expect(renderer.toc[0][:children].map {|heading| heading[:text] }).to eq ["Second", "Third"]
      expect(renderer.toc[1][:children]).to eq []
    end

    it "深い見出しの後に浅い見出しが現れた場合はネストの基準を浅い方に切り替える" do
      renderer.header("A", 3)
      renderer.header("B", 2)
      renderer.header("C", 3)

      expect(renderer.toc.map {|heading| heading[:text] }).to eq ["A", "B"]
      expect(renderer.toc[0][:children]).to eq []
      expect(renderer.toc[1][:children].map {|heading| heading[:text] }).to eq ["C"]
    end
  end

  describe "#image" do
    it "最初の画像ならimgタグを返しprimary_imageを設定する" do
      result = renderer.image("first.png", nil, nil)
      expect(result).to eq '<img src="first.png" alt="image" />'
      expect(renderer.primary_image).to eq "first.png"
    end

    it "後続の画像でprimary_imageを上書きしない" do
      renderer.image("first.png", nil, nil)
      renderer.image("second.png", nil, nil)
      expect(renderer.primary_image).to eq "first.png"
    end
  end

  describe "#block_code" do
    it "HTMLをエスケープしたpre/codeブロックを返す" do
      code = 'puts "Hello" < & >'
      result = renderer.block_code(code, "ruby")
      expect(result).to include('class="language-ruby"')
      expect(result).to include("puts &quot;Hello&quot; &lt; &amp; &gt;")
    end

    it "langがnilの場合は言語をtextにする" do
      result = renderer.block_code("code", nil)
      expect(result).to include('class="language-text"')
    end
  end
end
