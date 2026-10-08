# frozen_string_literal: true

require "simpress/entry"

describe Simpress::Entry do
  let(:date) { Time.new(2026, 1, 1) }

  let(:params) do
    {
      id: "entry-123",
      title: "Sample Entry",
      date: date,
      permalink: "/sample-entry",
      description: "Short description",
      cover: "cover.png",
      layout: "default",
      index: true,
      draft: false,
      markdown: "Main content here",
      content: "<p>Main content here</p>",
      toc: [{ id: "section-1", text: "Heading", children: [] }],
      taxonomies: { "categories" => [] }
    }
  end

  describe "#initialize" do
    it "プロパティを設定する" do
      entry = described_class.new(params)
      expect(entry.id).to eq "entry-123"
      expect(entry.title).to eq "Sample Entry"
      expect(entry.date).to eq date
      expect(entry.permalink).to eq "/sample-entry"
      expect(entry.description).to eq "Short description"
      expect(entry.cover).to eq "cover.png"
      expect(entry.markdown).to eq "Main content here"
      expect(entry.content).to eq "<p>Main content here</p>"
      expect(entry.toc).to eq [{ id: "section-1", text: "Heading", children: [] }]
      expect(entry.taxonomies).to eq({ "categories" => [] })
      expect(entry.prev).to be_nil
      expect(entry.next).to be_nil
    end
  end

  describe "#prev and #next" do
    it "デフォルトはnilで、代入できる" do
      entry = described_class.new(params)
      expect(entry.prev).to be_nil
      expect(entry.next).to be_nil

      link = Simpress::Entry::Link.new(entry)
      entry.prev = link
      entry.next = link
      expect(entry.prev).to eq link
      expect(entry.next).to eq link
    end
  end

  describe "#to_h" do
    it "許可されたjsonキーのみを含み、デフォルトではprevとnextがnilのハッシュを返す" do
      entry = described_class.new(params)
      result = entry.to_h
      expect(result.keys).to match_array(described_class::PERMITTED_JSON_KEYS)
      expect(result[:id]).to eq "entry-123"
      expect(result[:prev]).to be_nil
      expect(result[:next]).to be_nil
    end

    it "特定のキーが要求された場合はキーを絞り込む" do
      entry = described_class.new(params)
      result = entry.to_h(keys: [:title, :permalink])
      expect(result.keys).to contain_exactly(:title, :permalink)
    end

    it "代入されたprevとnextを含む" do
      newer = described_class.new(id: "entry-456", title: "Newer Entry", permalink: "/newer-entry")
      older = described_class.new(id: "entry-789", title: "Older Entry", permalink: "/older-entry")
      entry = described_class.new(params)
      entry.prev = Simpress::Entry::Link.new(older)
      entry.next = Simpress::Entry::Link.new(newer)
      result = entry.to_h
      expect(result[:prev]).to eq entry.prev
      expect(result[:next]).to eq entry.next
    end
  end

  describe "#as_json" do
    it "#to_hと同じハッシュを返す" do
      entry = described_class.new(params)
      expect(entry.as_json).to eq entry.to_h
    end
  end

  describe "#to_json" do
    let(:json_output) { '{"id":"entry-123"}' }

    it "Simpress::JSONを使ってハッシュをダンプする" do
      entry = described_class.new(params)
      allow(Simpress::JSON).to receive(:dump).and_return(json_output)
      result = entry.to_json
      expect(Simpress::JSON).to have_received(:dump).with(entry.as_json)
      expect(result).to eq json_output
    end
  end

  describe Simpress::Entry::Link do
    let(:entry) { Simpress::Entry.new(params) }
    let(:expected) { { id: "entry-123", title: "Sample Entry", permalink: "/sample-entry" } }

    describe ".build" do
      it "指定されたエントリをラップしたLinkを返し、entryがnilの場合はnilを返す" do
        link = described_class.build(entry)
        expect(link).to be_a(described_class)
        expect(link.id).to eq entry.id
        expect(link.title).to eq entry.title
        expect(link.permalink).to eq entry.permalink
        expect(described_class.build(nil)).to be_nil
      end
    end

    describe "#to_h" do
      it "id、title、permalinkのみを持つハッシュを返す" do
        expect(described_class.new(entry).to_h).to eq expected
      end
    end

    describe "#as_json" do
      it "#to_hと同じハッシュを返す" do
        link = described_class.new(entry)
        expect(link.as_json).to eq link.to_h
      end
    end

    describe "#to_json" do
      it "JSON文字列にシリアライズする" do
        link = described_class.new(entry)
        expect(Simpress::JSON.load(link.to_json, symbolize_names: true)).to eq expected
      end
    end
  end
end
