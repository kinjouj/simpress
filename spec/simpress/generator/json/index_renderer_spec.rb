# frozen_string_literal: true

require "simpress/generator/json/index_renderer"

describe Simpress::Generator::Json::IndexRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write)
  end

  let(:post) { build_post_data(1) }

  it "test" do
    expect { described_class.generate([post], 1) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write).with("/archives/page/1.json", [post].to_json)
  end
end
