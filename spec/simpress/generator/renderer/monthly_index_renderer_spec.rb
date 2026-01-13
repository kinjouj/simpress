# frozen_string_literal: true

require "simpress/post"
require "simpress/generator/renderer/monthly_index_renderer"

describe Simpress::Generator::Renderer::MonthlyIndexRenderer do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  let(:post1) { build_post_data(1, date: Time.new(2025, 11, 1)) }
  let(:post2) { build_post_data(2, date: Time.new(2025, 11, 2)) }
  let(:monthly_posts) { { Time.new(2025, 11, 1) => [post1, post2] } }

  describe ".generate_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("monthly index")
    end

    it "正常にgenerate_htmlメソッドが呼ばれること" do
      expect { described_class.generate_html(monthly_posts) }.not_to raise_error
      expect(File).to have_received(:write).with("public/archives/2025/11/index.html", "monthly index")
    end
  end

  describe ".generate_json" do
    it "正常にgenerate_jsonメソッドが呼ばれること" do
      expect { described_class.generate_json(monthly_posts) }.not_to raise_error
      expect(File).to have_received(:write).with(
        "public/archives/2025/11.json",
        monthly_posts[Time.new(2025, 11, 1)].to_json
      )
      expect(Simpress::Logger).to have_received(:info)
    end
  end
end
