# frozen_string_literal: true

require "simpress/generator/renderer/archive/monthly_renderer"
require "simpress/post"

describe Simpress::Generator::Renderer::Archive::MonthlyRenderer do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Writer).to receive(:write).and_yield(anything)
  end

  let(:post1) { build(:post, date: Time.new(2025, 11, 1)) }
  let(:post2) { build(:post, date: Time.new(2025, 11, 2)) }
  let(:monthly_posts) { { Time.new(2025, 11, 1) => [post1, post2] } }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("monthly index")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      described_class.generate_html(monthly_posts)
      expect(Simpress::Writer).to have_received(:write).with("/archives/2025/11/index.html", "monthly index")
      expect(Simpress::Logger).to have_received(:info)
    end
  end

  describe ".generate_json" do
    let(:keys) { described_class::DATA_JSON_KEYS }

    it "正常にgenerate_jsonメソッドが呼ばれること" do
      described_class.generate_json(monthly_posts)
      expect(Simpress::Writer).to have_received(:write).with(
        "/archives/2025/11/1.json",
        Simpress::JSON.dump(monthly_posts[Time.new(2025, 11, 1)], keys: keys)
      )
      expect(Simpress::Writer).to have_received(:write).with(
        "/archives/2025/11/meta.json",
        anything
      )
      expect(Simpress::Logger).to have_received(:info).exactly(2)
    end
  end
end
