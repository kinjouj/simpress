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

    context "when multiple notes exist" do
      let(:markdown) do
        <<~MARKDOWN
          > [!NOTE] First note.
          Some text.
          > [!NOTE] Second note.
        MARKDOWN
      end

      let(:expected) do
        <<~HTML
          <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>First note.</span></div>
          Some text.
          <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>Second note.</span></div>
        HTML
      end

      it "converts each note" do
        expect(described_class.preprocess(markdown.dup)).to eq expected
      end
    end

    context "when the blockquote continues after the marker line" do
      let(:markdown) do
        <<~MARKDOWN
          > [!NOTE] First line.
          > Second line.
        MARKDOWN
      end

      let(:expected) do
        <<~HTML
          <div class="note"><i class="fa-solid fa-circle-exclamation"></i><span>First line.</span></div>
          > Second line.
        HTML
      end

      it "converts only the marker line" do
        expect(described_class.preprocess(markdown.dup)).to eq expected
      end
    end

    context "when the blockquote is not a note" do
      it "doesn't convert" do
        data = "> Quote."
        expect(described_class.preprocess(data.dup)).to eq data
      end
    end

    context "when the marker is not NOTE" do
      it "doesn't convert" do
        data = "> [!TIP] Tip."
        expect(described_class.preprocess(data.dup)).to eq data
      end
    end

    context "when not at line start" do
      it "doesn't convert" do
        data = "Text before > [!NOTE] Not a note."
        expect(described_class.preprocess(data.dup)).to eq data
      end
    end

    context "when no space follows the marker" do
      it "doesn't convert" do
        data = "> [!NOTE]Not a note."
        expect(described_class.preprocess(data.dup)).to eq data
      end
    end

    context "when no text follows the marker" do
      let(:markdown) do
        <<~MARKDOWN
          > [!NOTE]
          > Text.
        MARKDOWN
      end

      it "doesn't convert" do
        expect(described_class.preprocess(markdown.dup)).to eq markdown
      end
    end
  end
end
