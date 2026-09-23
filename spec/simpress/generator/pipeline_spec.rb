# frozen_string_literal: true

require "simpress/generator/pipeline"
require "simpress/post"

describe Simpress::Generator::Pipeline do
  let(:post1) { build(:post, date: Time.new(2026, 1, 15)) }
  let(:post2) { build(:post, date: Time.new(2026, 1, 10)) }
  let(:posts) { [post1, post2] }
  let(:taxonomy) { Simpress::Taxonomy.fetch("categories") }

  before do
    allow(Simpress::Taxonomy).to receive(:taxonomies).and_return([taxonomy])
    allow(Simpress::Generator::Pipeline::Permalink).to receive(:generate)
    allow(Simpress::Generator::Pipeline::Archive::PostIndex).to receive(:generate)
    allow(Simpress::Generator::Pipeline::Archive::Monthly).to receive(:generate)
    allow(Simpress::Generator::Pipeline::Archive::Taxonomy).to receive(:generate)
  end

  after { Simpress::Taxonomy.clear }

  describe ".generate" do
    it "delegates to each pipeline with correct arguments" do
      described_class.generate(posts)
      expect(Simpress::Generator::Pipeline::Permalink).to have_received(:generate).with(post1)
      expect(Simpress::Generator::Pipeline::Permalink).to have_received(:generate).with(post2)
      expect(Simpress::Generator::Pipeline::Archive::Monthly).to have_received(:generate).with({ Time.new(2026, 1, 1) => [post1, post2] })
      expect(Simpress::Generator::Pipeline::Archive::PostIndex).to have_received(:generate).with(posts)
      expect(Simpress::Generator::Pipeline::Archive::Taxonomy).to have_received(:generate).with([taxonomy])
    end
  end
end
