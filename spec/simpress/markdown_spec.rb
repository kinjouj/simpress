# frozen_string_literal: true

require "simpress/markdown"

describe Simpress::Markdown do
  let(:data) do
    <<~MARKDOWN
      ---
      title: test
      date: 2025-01-01 00:00:00
      categories:
        - test
      ---

      test
    MARKDOWN
  end

  it "parser test" do
    metadata, body = described_class.parse(data)
    expect(metadata).not_to be_nil
    expect(body).not_to be_nil
    expect { described_class.parse("") }.to raise_error("PARSE ERROR")
  end
end
