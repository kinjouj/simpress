# frozen_string_literal: true

require "simpress/markdown"

describe Simpress::Markdown do
  let(:markdown_text) do
    <<~MARKDOWN
      ---
      title: test
      date: 2025-01-01 00:00:00
      permalink: /test.html
      categories:
      - test
      ---

      test1

      test2

      test3
    MARKDOWN
  end

  it "Markdownを正しくパースしてメタデータ・本文・説明を取得できること" do
    metadata, body = described_class.parse(markdown_text)
    expect(metadata).not_to be_nil
    expect(body).not_to be_nil
    expect { described_class.parse("") }.to raise_error("Markdown parse failed")
  end
end
