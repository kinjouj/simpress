# frozen_string_literal: true

require "simpress/entry"
require "simpress/taxonomy"

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
      categories: ["Ruby"]
    }
  end

  let(:rendered_content) { "<p>Main content here</p>" }
  let(:render_result) do
    Simpress::Parser::Markdown::Processor::Result.new(
      content: rendered_content,
      toc: [{ id: "section-1", text: "Heading", children: [] }],
      links: ["/2026/01/other.html"],
      cover: "/images/extracted.png"
    )
  end

  before do
    allow(Simpress::Config.instance).to receive(:taxonomies).and_return({ "categories" => { "Ruby" => "ruby" } })
    allow(Simpress::Parser::Markdown::Processor).to receive(:render).and_return(render_result)
  end

  after do
    Simpress::Taxonomy.clear
  end

  describe "#initialize" do
    it "プロパティを設定する" do
      entry = described_class.new(params)
      expect(entry.id).to eq "entry-123"
      expect(entry.title).to eq "Sample Entry"
      expect(entry.date).to eq date
      expect(entry.permalink).to eq "/sample-entry"
      expect(entry.prev).to be_nil
      expect(entry.next).to be_nil
    end

    it "実際のタクソノミーのtermと連携するが、まだ自身は登録しない" do
      entry = described_class.new(params)
      category_terms = entry.taxonomies["categories"]
      expect(category_terms.size).to eq 1
      expect(category_terms.first.name).to eq "Ruby"
      expect(category_terms.first.entries).not_to include(entry)
    end

    it "#load!が呼ばれるまでMarkdown本文をレンダリングしない" do
      entry = described_class.new(params)
      expect(Simpress::Parser::Markdown::Processor).not_to have_received(:render)
      expect(entry.content).to be_nil
      expect(entry.toc).to be_nil
      expect(entry.links).to be_nil
    end
  end

  describe "#load!" do
    it "Markdown本文をレンダリングしてcontent/toc/links/coverを設定する" do
      entry = described_class.new(params)
      entry.load!
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).with("Main content here")
      expect(entry.content).to eq rendered_content
      expect(entry.toc).to eq [{ id: "section-1", text: "Heading", children: [] }]
      expect(entry.links).to eq ["/2026/01/other.html"]
    end

    it "2回目以降の呼び出しでは再レンダリングしない" do
      entry = described_class.new(params)
      entry.load!
      entry.load!
      expect(Simpress::Parser::Markdown::Processor).to have_received(:render).once
    end

    it "本文から抽出したcoverよりparamsで指定されたcoverを優先する" do
      entry = described_class.new(params)
      entry.load!
      expect(entry.cover).to eq "cover.png"
    end

    it "本文から抽出したdescriptionよりparamsで指定されたdescriptionを優先する" do
      entry = described_class.new(params)
      entry.load!
      expect(entry.description).to eq "Short description"
    end

    context "paramsでdescriptionが指定されていない場合" do
      let(:params) { super().except(:description) }
      let(:rendered_content) { "<p>First paragraph.</p>\n<p>Second paragraph.</p>" }

      it "レンダリングされた本文の最初の段落のテキストにフォールバックする" do
        entry = described_class.new(params)
        entry.load!
        expect(entry.description).to eq "First paragraph."
      end
    end

    context "paramsでdescriptionが指定されておらず、最初の段落にインラインタグが含まれる場合" do
      let(:params) { super().except(:description) }
      let(:rendered_content) { "<p>Hello <strong>world</strong>!</p>" }

      it "抽出したdescriptionからインラインタグを取り除く" do
        entry = described_class.new(params)
        entry.load!
        expect(entry.description).to eq "Hello strongworld/strong!"
      end
    end

    context "paramsでcoverが指定されていない場合" do
      let(:params) { super().except(:cover) }

      it "本文から抽出した画像にフォールバックする" do
        entry = described_class.new(params)
        entry.load!
        expect(entry.cover).to eq "/images/extracted.png"
      end
    end

    context "paramsでcoverが指定されておらず、本文から画像も抽出されなかった場合" do
      let(:params) { super().except(:cover) }
      let(:render_result) do
        Simpress::Parser::Markdown::Processor::Result.new(content: rendered_content, toc: [], links: [], cover: nil)
      end

      it "デフォルトのcoverにフォールバックする" do
        entry = described_class.new(params)
        entry.load!
        expect(entry.cover).to eq described_class::DEFAULT_COVER
      end
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
    it "許可されたjsonキーのみを含むハッシュを返す" do
      entry = described_class.new(params)
      entry.load!
      result = entry.to_h
      expect(result.keys).to match_array(described_class::PERMITTED_JSON_KEYS)
      expect(result[:id]).to eq "entry-123"
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
      entry.load!
      entry.prev = Simpress::Entry::Link.new(older)
      entry.next = Simpress::Entry::Link.new(newer)
      result = entry.to_h
      expect(result[:prev]).to eq entry.prev
      expect(result[:next]).to eq entry.next
    end

    it "デフォルトではnilのprevとnextを含む" do
      entry = described_class.new(params)
      entry.load!
      result = entry.to_h
      expect(result[:prev]).to be_nil
      expect(result[:next]).to be_nil
    end
  end

  describe "#as_json" do
    it "#to_hと同じハッシュを返す" do
      entry = described_class.new(params)
      entry.load!
      expect(entry.as_json).to eq entry.to_h
    end
  end

  describe "#to_json" do
    let(:json_output) { '{"id":"entry-123"}' }

    it "Simpress::JSONを使ってハッシュをダンプする" do
      entry = described_class.new(params)
      entry.load!
      allow(Simpress::JSON).to receive(:dump).and_return(json_output)
      result = entry.to_json
      expect(Simpress::JSON).to have_received(:dump).with(entry.as_json)
      expect(result).to eq json_output
    end
  end
end
