# frozen_string_literal: true

require "simpress/markdown"

describe Simpress::Markdown do
  it "parser test" do
    metadata, body = described_class.parse(fixture("test.markdown").read)
    expect(metadata).not_to be_nil
    expect(body).not_to be_nil
    expect { described_class.parse("") }.to raise_error("PARSE ERROR")
  end
end
