# frozen_string_literal: true

require "simpress/generator/json/page_info_renderer"

describe Simpress::Generator::Json::PageInfoRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write)
  end

  it "test" do
    expect { described_class.generate(10) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write).with("/pageinfo.json", { page: 10 }.to_json)
  end
end
