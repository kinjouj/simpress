# frozen_string_literal: true

require "simpress/generator/json/monthly_index_renderer"

describe Simpress::Generator::Json::MonthlyIndexRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write)
  end

  let(:post1) { build_post_data(1, date: DateTime.new(2025, 12, 1)) }
  let(:post2) { build_post_data(2, date: DateTime.new(2025, 12, 2)) }
  let(:monthly_posts) do
    hash = {}
    hash[DateTime.new(2025, 12, 1)] = [post1, post2]
    hash
  end

  it "test" do
    expect { described_class.generate(monthly_posts) }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).exactly(1).times
    expect(Simpress::Writer).to have_received(:write).with("/archives/2025/12.json", anything)
  end
end
