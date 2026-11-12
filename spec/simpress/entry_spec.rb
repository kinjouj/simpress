# frozen_string_literal: true

require "simpress/entry"

describe Simpress::Entry do
  let(:date) do
    Time.new(2026, 1, 1)
  end

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
      taxonomies: { "categories" => [] },
      og_image: "/images/og.png"
    }
  end

  describe "#initialize" do
    it "sets the properties" do
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
      expect(entry.params).to eq params
      expect(entry.params[:og_image]).to eq "/images/og.png"
      expect(entry.prev).to be_nil
      expect(entry.next).to be_nil
    end
  end

  describe "#prev and #next" do
    it "defaults to nil, assignable" do
      entry = described_class.new(params)

      expect(entry.prev).to be_nil
      expect(entry.next).to be_nil

      link = Simpress::Entry::Link.build(entry)
      entry.prev = link
      entry.next = link
      expect(entry.prev).to eq link
      expect(entry.next).to eq link
    end
  end

  describe "#to_h" do
    it "returns allowed json keys only" do
      entry = described_class.new(params)
      result = entry.to_h

      expect(result.keys).to match_array(described_class::PERMITTED_JSON_KEYS)
      expect(result[:id]).to eq "entry-123"
      expect(result[:prev]).to be_nil
      expect(result[:next]).to be_nil
    end

    context "when specific keys are requested" do
      it "narrows the keys" do
        entry = described_class.new(params)
        result = entry.to_h(keys: [:title, :permalink])

        expect(result.keys).to contain_exactly(:title, :permalink)
      end
    end

    it "includes assigned prev and next" do
      newer = described_class.new(id: "entry-456", title: "Newer Entry", permalink: "/newer-entry")
      older = described_class.new(id: "entry-789", title: "Older Entry", permalink: "/older-entry")
      entry = described_class.new(params)
      entry.prev = Simpress::Entry::Link.build(older)
      entry.next = Simpress::Entry::Link.build(newer)
      result = entry.to_h

      expect(result[:prev]).to eq entry.prev
      expect(result[:next]).to eq entry.next
    end
  end

  describe "#as_json" do
    it "returns the #to_h hash" do
      entry = described_class.new(params)

      expect(entry.as_json).to eq entry.to_h
    end
  end

  describe "#to_json" do
    it "returns a JSON string" do
      entry = described_class.new(params)
      json = Simpress::JSON.load(entry.to_json, symbol_keys: true)

      expect(json).to include(id: "entry-123", title: "Sample Entry", permalink: "/sample-entry")
    end
  end

  describe Simpress::Entry::Link do
    let(:entry) do
      Simpress::Entry.new(params)
    end

    let(:expected) do
      { id: "entry-123", title: "Sample Entry", permalink: "/sample-entry", cover: "cover.png" }
    end

    describe ".build" do
      it "builds a Link from entry" do
        link = described_class.build(entry)

        expect(link).to be_a(described_class)
        expect(link.id).to eq entry.id
        expect(link.title).to eq entry.title
        expect(link.permalink).to eq entry.permalink
      end

      context "when entry is nil" do
        it "returns nil" do
          expect(described_class.build(nil)).to be_nil
        end
      end
    end

    describe "#to_h" do
      it "returns id, title, permalink, cover" do
        expect(described_class.build(entry).to_h).to eq expected
      end
    end

    describe "#as_json" do
      it "returns the #to_h hash" do
        link = described_class.build(entry)

        expect(link.as_json).to eq link.to_h
      end
    end

    describe "#to_json" do
      it "serializes to a JSON string" do
        link = described_class.build(entry)

        expect(Simpress::JSON.load(link.to_json, symbolize_names: true)).to eq expected
      end
    end
  end
end
