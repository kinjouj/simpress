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
    context "modeがhtmlの場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
      end

      it "最初の5件のエントリのみをコンテキストにバインドする" do
        described_class.run(entries)
        expect(described_class).to have_received(:bind_context).with(recent_entries: entries.take(5))
      end

      it "エントリが5件未満の場合も扱える" do
        small_entries = entries.take(2)
        described_class.run(small_entries)
        expect(described_class).to have_received(:bind_context).with(recent_entries: small_entries)
      end

      it "entriesの入力がnilの場合も扱える" do
        described_class.run(nil)
        expect(described_class).to have_received(:bind_context).with(recent_entries: [])
      end
    end

    context "modeがjsonの場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      end

      it "最初の5件のエントリをrecent_entries.jsonに書き出す" do
        described_class.run(entries)

        expect(Simpress::JSON).to have_received(:dump).with(entries.take(5), keys: [:id, :title, :permalink])
        expect(Simpress::Writer).to have_received(:write).with("recent_entries.json", '{"json": true}')
      end
    end

    context "modeが不明な場合" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("xml")
      end

      it "エラーを発生させる" do
        expect { described_class.run(entries) }.to raise_error("Unknown mode: xml")
      end
    end
  end
end
