# frozen_string_literal: true

require "simpress/generator"

describe Simpress::Generator do
  let(:entry1) do
    build(:entry, date: Time.new(2025, 1, 1))
  end

  let(:entry2) do
    build(:entry, date: Time.new(2025, 6, 1))
  end

  before do
    allow(Dir).to receive(:glob).and_yield("draft.markdown").and_yield("entry1.markdown").and_yield("entry2.markdown")
    allow(Simpress::Parser).to receive(:parse).with("draft.markdown").and_return(build(:entry, draft: true))
    allow(Simpress::Parser).to receive(:parse).with("entry1.markdown").and_return(entry1)
    allow(Simpress::Parser).to receive(:parse).with("entry2.markdown").and_return(entry2)
    allow(Simpress::Plugin).to receive(:process)
    allow(Simpress::Generator::Pipeline).to receive(:generate)
    allow(Simpress::Theme).to receive(:clear)
  end

  describe ".generate" do
    it "generates the output" do
      described_class.generate

      expect(Simpress::Plugin).to have_received(:process).with([entry2, entry1]).ordered
      expect(Simpress::Generator::Pipeline).to have_received(:generate).ordered
      expect(Simpress::Theme).to have_received(:clear).ordered
    end
  end

  describe ".build_entry_relations!" do
    let(:entry_a) do
      build(:entry, permalink: "/entry-a.html")
    end

    let(:entry_b) do
      build(:entry, permalink: "/entry-b.html")
    end

    let(:entry_c) do
      build(:entry, permalink: "/entry-c.html")
    end

    before do
      described_class.send(:build_entry_relations!, [entry_a, entry_b, entry_c])
    end

    it "sets prev and next" do
      expect(entry_a.prev.permalink).to eq "/entry-b.html"
      expect(entry_a.next).to be_nil
      expect(entry_b.prev.permalink).to eq "/entry-c.html"
      expect(entry_b.next.permalink).to eq "/entry-a.html"
      expect(entry_c.prev).to be_nil
      expect(entry_c.next.permalink).to eq "/entry-b.html"
    end

    it "excludes entries with index false" do
      newer = build(:entry, permalink: "/newer.html")
      hidden = build(:entry, permalink: "/hidden.html", index: false)
      older = build(:entry, permalink: "/older.html")
      described_class.send(:build_entry_relations!, [newer, hidden, older])

      expect(newer.prev.permalink).to eq "/older.html"
      expect(older.next.permalink).to eq "/newer.html"
      expect(hidden.prev).to be_nil
      expect(hidden.next).to be_nil
    end
  end
end
