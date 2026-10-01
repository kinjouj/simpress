# frozen_string_literal: true

require "simpress/plugin/recent_entries"
require "simpress/entry"

describe Simpress::Plugin::RecentEntries do
  let(:entries) do
    Array.new(10) do |i|
      Simpress::Entry.new(id: "entry-#{i}", title: "Title #{i}", permalink: "/entry-#{i}")
    end
  end

  before do
    allow(described_class).to receive(:bind_context)
    allow(Simpress::Config.instance).to receive(:mode)
    allow(Simpress::Writer).to receive(:write)
    allow(Simpress::JSON).to receive(:dump).and_return('{"json": true}')
  end

  after do
    Simpress::Taxonomy.clear
    Simpress::Plugin.clear
  end

  describe ".run" do
    context "when mode is html" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
      end

      it "binds only the first 5 entries to the context" do
        described_class.run(entries)
        expect(described_class).to have_received(:bind_context).with(recent_entries: entries.take(5))
      end

      it "handles fewer than 5 entries" do
        small_entries = entries.take(2)
        described_class.run(small_entries)
        expect(described_class).to have_received(:bind_context).with(recent_entries: small_entries)
      end

      it "handles nil entries input" do
        described_class.run(nil)
        expect(described_class).to have_received(:bind_context).with(recent_entries: [])
      end
    end

    context "when mode is json" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      end

      it "writes the first 5 entries to recent_entries.json" do
        described_class.run(entries)

        expect(Simpress::JSON).to have_received(:dump).with(entries.take(5), keys: [:id, :title, :permalink])
        expect(Simpress::Writer).to have_received(:write).with("recent_entries.json", '{"json": true}')
      end
    end

    context "when mode is unknown" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("xml")
      end

      it "raises an error" do
        expect { described_class.run(entries) }.to raise_error("Unknown mode: xml")
      end
    end
  end
end
