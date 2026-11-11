# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"
require "simpress/generator/pipeline"

describe Simpress::Generator::Pipeline do
  let(:taxonomy) do
    Simpress::Taxonomy.fetch("categories")
  end

  before do
    allow(Simpress::Taxonomy).to receive(:taxonomies).and_return([taxonomy])
    allow(Simpress::Generator::Pipeline::Permalink).to receive(:generate)
    allow(Simpress::Generator::Pipeline::Archive::EntryIndex).to receive(:generate)
    allow(Simpress::Generator::Pipeline::Archive::Monthly).to receive(:generate)
    allow(Simpress::Generator::Pipeline::Archive::Taxonomy).to receive(:generate)
  end

  after do
    Simpress::Taxonomy.clear
  end

  describe ".generate" do
    let(:entry1) do
      build(:entry, date: Time.new(2026, 1, 15))
    end

    let(:entry2) do
      build(:entry, date: Time.new(2026, 1, 10))
    end

    let(:entries) do
      [entry1, entry2]
    end

    it "各パイプラインを実行する" do
      described_class.generate(entries)

      expect(Simpress::Generator::Pipeline::Permalink).to have_received(:generate).with(entry1)
      expect(Simpress::Generator::Pipeline::Permalink).to have_received(:generate).with(entry2)
      expect(Simpress::Generator::Pipeline::Archive::Monthly).to have_received(:generate).with({ [2026, 1] => [entry1, entry2] })
      expect(Simpress::Generator::Pipeline::Archive::EntryIndex).to have_received(:generate).with(entries)
      expect(Simpress::Generator::Pipeline::Archive::Taxonomy).to have_received(:generate).with([taxonomy])
    end
  end
end
