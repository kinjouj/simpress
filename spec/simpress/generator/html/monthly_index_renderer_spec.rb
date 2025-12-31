# frozen_string_literal: true

require "simpress/generator/html/monthly_index_renderer"

describe Simpress::Generator::Html::MonthlyIndexRenderer do
  let(:post1) do
    build_post_data(1, date: DateTime.new(2025, 11, 15))
  end

  let(:post2) do
    build_post_data(2, date: DateTime.new(2025, 12, 1))
  end

  let(:data) do
    date = DateTime.new(2025, 12, 1)
    data = {}
    data[date] = [post1, post2]
    data
  end

  before do
    allow(Simpress::Generator::Html::IndexRenderer).to receive(:generate)
  end

  it "sorts posts in descending order by date" do
    expect { described_class.generate(data) }.not_to raise_error
    expect(Simpress::Generator::Html::IndexRenderer).to have_received(:generate).with([post1, post2], anything, "2025/12")
  end
end
