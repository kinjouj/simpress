# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"
require "simpress/plugin/recent_entries"

describe Simpress::Plugin::RecentEntries do
  let(:entries) do
    Array.new(10) {|i| Simpress::Entry.new(id: "entry-#{i}", title: "Title #{i}", permalink: "/entry-#{i}", index: true) }
  end

  before do
    allow(described_class).to receive(:bind_context)
    allow(Simpress::Config).to receive(:mode)
    allow(Simpress::Writer).to receive(:write)
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Plugin.clear
  end

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("html")
      end

      it "binds the first 5 entries" do
        described_class.run(entries)

        expect(described_class).to have_received(:bind_context).with(recent_entries: entries.take(5))
      end

      context "when an entry has index false" do
        it "excludes the entry" do
          hidden = Simpress::Entry.new(id: "hidden", title: "Hidden", permalink: "/hidden", index: false)
          described_class.run([hidden, *entries])

          expect(described_class).to have_received(:bind_context).with(recent_entries: entries.take(5))
        end
      end

      context "when there are fewer than 5 entries" do
        it "binds all the entries" do
          small_entries = entries.take(2)
          described_class.run(small_entries)

          expect(described_class).to have_received(:bind_context).with(recent_entries: small_entries)
        end
      end
    end

    context "when mode is json" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("json")
      end

      it "outputs recent_entries.json" do
        described_class.run(entries)

        expect(Simpress::Writer).to have_received(:write) do |path, json|
          data = Simpress::JSON.load(json)
          expect(path).to eq "recent_entries.json"
          expect(data.map {|entry| entry["id"] }).to eq ["entry-0", "entry-1", "entry-2", "entry-3", "entry-4"]
          expect(data.first.keys).to contain_exactly("id", "title", "permalink")
        end
      end
    end

    context "when mode is unknown" do
      before do
        allow(Simpress::Config).to receive(:mode).and_return("xml")
      end

      it "raises an error" do
        expect { described_class.run(entries) }.to raise_error("Unknown mode: xml")
      end
    end
  end
end
