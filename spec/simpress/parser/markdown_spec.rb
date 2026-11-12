# frozen_string_literal: true

require "simpress/parser/markdown"

describe Simpress::Parser::Markdown do
  describe ".parse" do
    let(:markdown) do
      <<~MARKDOWN
        ---
        title: test
        date: 2026-01-01 00:00:00
        ---

        TEST MARKDOWN
      MARKDOWN
    end

    before do
      allow(File).to receive(:read).and_return(markdown)
    end

    it "returns the header and body" do
      header, result_body = described_class.parse("test.markdown")

      expect(header[:title]).to eq "test"
      expect(header[:date]).to be_a(Time)
      expect(result_body.strip).to eq "TEST MARKDOWN"
    end

    context "when front matter is missing" do
      let(:markdown) do
        <<~MARKDOWN
          No front matter here
        MARKDOWN
      end

      it "raises error with file name" do
        expect { described_class.parse("test.markdown") }.to raise_error("Markdown parse failed: test.markdown")
      end
    end

    context "when front matter is empty" do
      let(:markdown) do
        <<~MARKDOWN
          ---
          ---
          body
        MARKDOWN
      end

      it "raises error with file name" do
        expect { described_class.parse("test.markdown") }.to raise_error("Front matter must be a mapping: test.markdown")
      end
    end

    context "when front matter isn't Hash" do
      let(:markdown) do
        <<~MARKDOWN
          ---
          - a
          - b
          ---
          body
        MARKDOWN
      end

      it "raises error with file name" do
        expect { described_class.parse("test.markdown") }.to raise_error("Front matter must be a mapping: test.markdown")
      end
    end

    context "when YAML front matter invalid" do
      let(:markdown) do
        <<~MARKDOWN
          ---
          title: [unclosed
          ---
          body
        MARKDOWN
      end

      it "raises error with file name" do
        expect { described_class.parse("test.markdown") }.to raise_error(Psych::SyntaxError, /test\.markdown/)
      end
    end
  end
end
