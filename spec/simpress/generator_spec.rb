# frozen_string_literal: true

require "simpress/generator"

describe Simpress::Generator do
  let(:draft_entry) { build(:entry, draft: true) }
  let(:entry1) { build(:entry, date: Time.new(2025, 1, 1)) }
  let(:entry2) { build(:entry, date: Time.new(2025, 6, 1)) }

  before do
    allow(Dir).to receive(:glob).and_yield("draft.markdown")
                                .and_yield("entry1.markdown")
                                .and_yield("entry2.markdown")
    allow(Simpress::Parser).to receive(:parse).with("draft.markdown").and_return(draft_entry)
    allow(Simpress::Parser).to receive(:parse).with("entry1.markdown").and_return(entry1)
    allow(Simpress::Parser).to receive(:parse).with("entry2.markdown").and_return(entry2)
    allow(Simpress::Plugin).to receive(:process)
    allow(Simpress::Generator::Pipeline).to receive(:generate)
    allow(Simpress::Theme).to receive(:clear)
  end

  after { described_class.clear }

  describe ".clear" do
    it "resets link_index to nil" do
      described_class.send(:build_entry_relations!, [build(:entry)])
      expect(described_class.link_index).not_to be_nil
      described_class.clear
      expect(described_class.link_index).to be_nil
    end
  end

  describe ".each_file" do
    it "raises when called without a block" do
      expect { described_class.each_file }.to raise_error("block is required")
    end

    it "yields each markdown file path found under source_dir" do
      allow(Dir).to receive(:glob).and_yield("entry1.markdown").and_yield("entry2.markdown")
      yielded = []
      described_class.each_file {|file| yielded << file }
      expect(Dir).to have_received(:glob).with("source/**/*.markdown")
      expect(yielded).to eq ["entry1.markdown", "entry2.markdown"]
    end
  end

  describe ".generate" do
    it "globs markdown files under source_dir" do
      described_class.generate
      expect(Dir).to have_received(:glob).with("source/**/*.markdown")
    end

    it "skips drafts and passes remaining entries sorted by timestamp descending" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process) do |entries|
        expect(entries).not_to include(draft_entry)
        expect(entries).to eq([entry2, entry1])
      end
    end

    it "executes the generation pipeline in the correct order" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process).ordered
      expect(Simpress::Generator::Pipeline).to have_received(:generate).ordered
      expect(Simpress::Theme).to have_received(:clear).ordered
    end
  end

  describe ".build_entry_relations!" do
    let(:entry_a) { build(:entry, permalink: "/entry-a.html", title: "Entry A", markdown: "[b](/entry-b.html) [c](/entry-c.html)") }
    let(:entry_b) { build(:entry, permalink: "/entry-b.html", title: "Entry B", markdown: "[a](/entry-a.html)") }
    let(:entry_c) { build(:entry, permalink: "/entry-c.html", title: "Entry C", markdown: "no links here") }

    before { described_class.send(:build_entry_relations!, [entry_a, entry_b, entry_c]) }

    it "sets inbound links correctly" do
      expect(entry_a.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/entry-b.html", "Entry B"])
      expect(entry_b.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/entry-a.html", "Entry A"])
      expect(entry_c.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/entry-a.html", "Entry A"])
    end

    it "ignores links not matching any entry permalink" do
      entry = build(:entry, permalink: "/entry-x.html", markdown: "[external](https://example.com)")
      described_class.send(:build_entry_relations!, [entry])
      expect(entry.backlinks).to be_empty
    end

    it "assigns next to the newer entry and prev to the older entry" do
      expect(entry_a.prev.permalink).to eq "/entry-b.html"
      expect(entry_a.next).to be_nil
      expect(entry_b.prev.permalink).to eq "/entry-c.html"
      expect(entry_b.next.permalink).to eq "/entry-a.html"
      expect(entry_c.prev).to be_nil
      expect(entry_c.next.permalink).to eq "/entry-b.html"
    end

    it "freezes each entry" do
      expect(entry_a).to be_frozen
      expect(entry_b).to be_frozen
      expect(entry_c).to be_frozen
    end
  end
end
