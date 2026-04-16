# frozen_string_literal: true

require "simpress/plugin/inline_note"

describe Simpress::Plugin::InlineNote do
  describe ".preprocess" do
    it "converts inline note syntax to html div with font-awesome icon" do
      markdown = "[^]: This is a note."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i>This is a note.</div>'
      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "ignores spaces after the colon but preserves note content" do
      markdown = "[^]:    Note with leading spaces."
      expected = '<div class="note"><i class="fa-solid fa-circle-exclamation"></i>Note with leading spaces.</div>'
      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "does not match if the syntax is not at the beginning of the line" do
      markdown = "Text before [^]: Not a note."
      expect(described_class.preprocess(markdown)).to eq markdown
    end

    it "matches multiple notes in different lines" do
      markdown = <<~MARKDOWN
        [^]: First note.
        Some text.
        [^]: Second note.
      MARKDOWN

      expected = <<~HTML
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i>First note.</div>
        Some text.
        <div class="note"><i class="fa-solid fa-circle-exclamation"></i>Second note.</div>
      HTML

      expect(described_class.preprocess(markdown)).to eq expected
    end

    it "does not match incomplete or slightly different syntax" do
      expect(described_class.preprocess("[^] : No space before colon")).to eq "[^] : No space before colon"
      expect(described_class.preprocess("[*]: Wrong bracket content")).to eq "[*]: Wrong bracket content"
    end
  end
end
