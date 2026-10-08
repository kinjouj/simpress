# frozen_string_literal: true

require "simpress/plugin/inline_note"

describe Simpress::Plugin::InlineNote do
  describe ".preprocess" do
    it "インラインnote記法をfont-awesomeアイコン付きのHTMLのdivに変換する" do
      markdown = "[^]: This is a note."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>This is a note.</span></div>'
      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "コロンの後のスペースは無視するがnoteの内容は保持する" do
      markdown = "[^]:    Note with leading spaces."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>Note with leading spaces.</span></div>'
      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "記法が行頭にない場合はマッチしない" do
      markdown = "Text before [^]: Not a note."
      expect(described_class.preprocess(markdown)).to eq markdown
    end

    it "異なる行にある複数のnoteにマッチする" do
      markdown = <<~MARKDOWN
        [^]: First note.
        Some text.
        [^]: Second note.
      MARKDOWN

      expected = <<~HTML
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>First note.</span></div>
        Some text.
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>Second note.</span></div>
      HTML

      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "不完全な記法や少し異なる記法にはマッチしない" do
      expect(described_class.preprocess("[^] : No space before colon")).to eq "[^] : No space before colon"
      expect(described_class.preprocess("[*]: Wrong bracket content")).to eq "[*]: Wrong bracket content"
    end
  end
end
