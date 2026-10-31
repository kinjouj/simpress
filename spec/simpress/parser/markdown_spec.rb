# frozen_string_literal: true

require "tmpdir"
require "simpress/parser/markdown"

describe Simpress::Parser::Markdown do
  describe ".parse" do
    let(:dir) { Dir.mktmpdir }
    let(:file) { File.join(dir, "test.markdown") }

    after do
      FileUtils.remove_entry(dir)
    end

    it "Time付きのヘッダーを正常にパースして本文を返す" do
      File.write(file, <<~MARKDOWN)
        ---
        title: Hello World
        date: 2026-01-01 10:00:00 +0900
        ---
        # Content
      MARKDOWN

      header, body = described_class.parse(file)
      expect(header[:title]).to eq "Hello World"
      expect(header[:date]).to be_a(Time)
      expect(body).to eq "# Content\n"
    end

    it "Markdownにフロントマターがない場合はファイル名付きのエラーを発生させる" do
      File.write(file, "No front matter here")
      expect { described_class.parse(file) }.to raise_error("#{file}: Markdown parse failed")
    end

    it "フロントマターのYAMLが不正な場合はファイル名付きのエラーを発生させる" do
      File.write(file, "---\ntitle: [unclosed\n---\nbody")
      expect { described_class.parse(file) }.to raise_error(Psych::SyntaxError, /#{Regexp.escape(file)}/)
    end
  end
end
