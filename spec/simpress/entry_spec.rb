# frozen_string_literal: true

require "simpress/entry"

describe Simpress::Entry do
  let(:date) do
    Time.new(2026, 1, 1)
  end

  let(:lastmod) do
    Time.new(2026, 2, 1)
  end

  let(:params) do
    {
      id: "entry-123",
      title: "Sample Entry",
      date: date,
      lastmod: lastmod,
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
      expect(entry.lastmod).to eq lastmod
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
    it "returns nil by default" do
      entry = described_class.new(params)

      expect(entry.prev).to be_nil
      expect(entry.next).to be_nil
    end

    it "returns the assigned links" do
      entry = described_class.new(params)
      link = entry.to_link
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

    context "when prev and next are assigned" do
      it "includes them" do
        newer = described_class.new(id: "entry-456", title: "Newer Entry", permalink: "/newer-entry")
        older = described_class.new(id: "entry-789", title: "Older Entry", permalink: "/older-entry")
        entry = described_class.new(params)
        entry.prev = older.to_link
        entry.next = newer.to_link
        result = entry.to_h

        expect(result[:prev]).to eq entry.prev
        expect(result[:next]).to eq entry.next
      end
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

  describe "#to_link" do
    let(:entry) do
      described_class.new(params)
    end

    it "returns a link to the entry" do
      link = entry.to_link

      expect(link.id).to eq entry.id
      expect(link.title).to eq entry.title
      expect(link.permalink).to eq entry.permalink
      expect(link.cover).to eq entry.cover
    end

    describe "#to_h" do
      it "returns id, title, permalink, cover" do
        expect(entry.to_link.to_h).to eq(id: "entry-123", title: "Sample Entry", permalink: "/sample-entry", cover: "cover.png")
      end
    end
  end
end
