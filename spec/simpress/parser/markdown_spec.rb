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

    it "ヘッダーと本文を返す" do
      header, result_body = described_class.parse("test.markdown")

      expect(header[:title]).to eq "test"
      expect(header[:date]).to be_a(Time)
      expect(result_body.strip).to eq "TEST MARKDOWN"
    end

    context "フロントマターがない場合" do
      let(:markdown) do
        <<~MARKDOWN
          No front matter here
        MARKDOWN
      end

      it "ファイル名付きのエラーを発生させる" do
        expect { described_class.parse("test.markdown") }.to raise_error("Markdown parse failed: test.markdown")
      end
    end

    context "フロントマターが空の場合" do
      let(:markdown) do
        <<~MARKDOWN
          ---
          ---
          body
        MARKDOWN
      end

      it "ファイル名付きのエラーを発生させる" do
        expect { described_class.parse("test.markdown") }.to raise_error("Front matter must be a mapping: test.markdown")
      end
    end

    context "フロントマターがHashでない場合" do
      let(:markdown) do
        <<~MARKDOWN
          ---
          - a
          - b
          ---
          body
        MARKDOWN
      end

      it "ファイル名付きのエラーを発生させる" do
        expect { described_class.parse("test.markdown") }.to raise_error("Front matter must be a mapping: test.markdown")
      end
    end

    context "フロントマターのYAMLが不正な場合" do
      let(:markdown) do
        <<~MARKDOWN
          ---
          title: [unclosed
          ---
          body
        MARKDOWN
      end

      it "ファイル名付きのエラーを発生させる" do
        expect { described_class.parse("test.markdown") }.to raise_error(Psych::SyntaxError, /test\.markdown/)
      end
    end
  end
end
