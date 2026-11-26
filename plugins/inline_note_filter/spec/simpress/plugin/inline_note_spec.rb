# frozen_string_literal: true

require "simpress/plugin/inline_note"

describe Simpress::Plugin::InlineNote do
  describe ".preprocess" do
    it "converts to HTML" do
      markdown = "> [!NOTE] This is a note."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>This is a note.</span></div>'
      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "ignores space around the marker" do
      markdown = ">   [!NOTE]    Note with leading spaces."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>Note with leading spaces.</span></div>'
      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "converts multiple notes" do
      markdown = <<~MARKDOWN
        > [!NOTE] First note.
        Some text.
        > [!NOTE] Second note.
      MARKDOWN

      expected = <<~HTML
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>First note.</span></div>
        Some text.
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>Second note.</span></div>
      HTML

      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "converts only the marker line" do
      markdown = <<~MARKDOWN
        > [!NOTE] First line.
        > Second line.
      MARKDOWN

      expected = <<~HTML
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>First line.</span></div>
        > Second line.
      HTML

      expect(described_class.preprocess(markdown)).to eq expected
    end

    context "when the blockquote is not a note" do
      it "doesn't convert" do
        markdown = "> Quote."
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end

    context "when the marker is not NOTE" do
      it "doesn't convert" do
        markdown = "> [!TIP] Tip."
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end

    context "when not at line start" do
      it "doesn't convert" do
        markdown = "Text before > [!NOTE] Not a note."
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end

    context "when no space follows the marker" do
      it "doesn't convert" do
        markdown = "> [!NOTE]Not a note."
        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end

    context "when no text follows the marker" do
      it "doesn't convert" do
        markdown = <<~MARKDOWN
          > [!NOTE]
          > Text.
        MARKDOWN

        expect(described_class.preprocess(markdown)).to eq markdown
      end
    end
  end
end
