# frozen_string_literal: true

require "simpress/plugin/inline_note"

describe Simpress::Plugin::InlineNote do
  describe ".preprocess" do
    it "converts to HTML" do
      markdown = "[^]: This is a note."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>This is a note.</span></div>'

      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "ignores space after colon" do
      markdown = "[^]:    Note with leading spaces."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>Note with leading spaces.</span></div>'

      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "converts multiple notes" do
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

    context "when not at line start" do
      it "doesn't convert" do
        markdown = "Text before [^]: Not a note."
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end

    context "when space precedes the colon" do
      it "doesn't convert" do
        markdown = "[^] : No space before colon"
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end

    context "when the bracket content differs" do
      it "doesn't convert" do
        markdown = "[*]: Wrong bracket content"
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end
  end
end
