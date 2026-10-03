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

  after do
    described_class.clear
  end

  describe ".clear" do
    it "link_indexをnilにリセットする" do
      described_class.send(:build_entry_relations!, [build(:entry)])
      expect(described_class.link_index).not_to be_nil
      described_class.clear
      expect(described_class.link_index).to be_nil
    end
  end

  describe ".each_file" do
    it "ブロックなしで呼び出された場合は例外を発生させる" do
      expect { described_class.each_file }.to raise_error("block is required")
    end

    it "source_dir配下で見つかった各Markdownファイルのパスをyieldする" do
      allow(Dir).to receive(:glob).and_yield("entry1.markdown").and_yield("entry2.markdown")
      yielded = []
      described_class.each_file {|file| yielded << file }
      expect(Dir).to have_received(:glob).with("source/**/*.markdown")
      expect(yielded).to eq ["entry1.markdown", "entry2.markdown"]
    end
  end

  describe ".generate" do
    it "下書きをスキップし、残りのエントリをタイムスタンプの降順で渡して、生成パイプラインを正しい順序で実行する" do
      described_class.generate
      expect(Simpress::Plugin).to have_received(:process).with([entry2, entry1]).ordered
      expect(Simpress::Generator::Pipeline).to have_received(:generate).ordered
      expect(Simpress::Theme).to have_received(:clear).ordered
    end
  end

  describe ".build_entry_relations!" do
    let(:entry_a) { build(:entry, permalink: "/entry-a.html", title: "Entry A", markdown: "[b](/entry-b.html) [c](/entry-c.html)") }
    let(:entry_b) { build(:entry, permalink: "/entry-b.html", title: "Entry B", markdown: "[a](/entry-a.html)") }
    let(:entry_c) { build(:entry, permalink: "/entry-c.html", title: "Entry C", markdown: "no links here") }

    before do
      described_class.send(:build_entry_relations!, [entry_a, entry_b, entry_c])
    end

    it "被リンクを設定し、新しいエントリにnext、古いエントリにprevを割り当てて、各エントリをfreezeする" do
      expect(entry_a.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/entry-b.html", "Entry B"])
      expect(entry_b.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/entry-a.html", "Entry A"])
      expect(entry_c.backlinks.map {|l| [l.permalink, l.title] }).to contain_exactly(["/entry-a.html", "Entry A"])

      expect(entry_a.prev.permalink).to eq "/entry-b.html"
      expect(entry_a.next).to be_nil
      expect(entry_b.prev.permalink).to eq "/entry-c.html"
      expect(entry_b.next.permalink).to eq "/entry-a.html"
      expect(entry_c.prev).to be_nil
      expect(entry_c.next.permalink).to eq "/entry-b.html"

      expect(entry_a).to be_frozen
      expect(entry_b).to be_frozen
      expect(entry_c).to be_frozen
    end

    it "どのエントリのpermalinkにも一致しないリンクは無視する" do
      entry = build(:entry, permalink: "/entry-x.html", markdown: "[external](https://example.com)")
      described_class.send(:build_entry_relations!, [entry])
      expect(entry.backlinks).to be_empty
    end
  end
end
