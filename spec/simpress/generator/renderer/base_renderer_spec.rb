# frozen_string_literal: true

require "spec_helper"
require "simpress/generator/renderer/base_renderer"

RSpec.describe Simpress::Generator::Renderer::BaseRenderer do
  before do
    allow(Simpress::Config.instance).to receive(:paginate).and_return(10)
  end

  describe ".generate" do
    context "modeがhtmlのとき" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("html")
        allow(described_class).to receive(:generate_html)
      end

      it "generate_htmlが実行されること" do
        described_class.generate(:arg1, :arg2)
        expect(described_class).to have_received(:generate_html).with(:arg1, :arg2)
      end
    end

    context "modeがjsonのとき" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("json")
        allow(described_class).to receive(:generate_json)
      end

      it "generate_jsonが実行されること" do
        described_class.generate(:arg1, :arg2)
        expect(described_class).to have_received(:generate_json).with(:arg1, :arg2)
      end
    end

    context "未知のmodeのとき" do
      before do
        allow(Simpress::Config.instance).to receive(:mode).and_return("xml")
      end

      it "RuntimeErrorをraiseする" do
        expect { described_class.generate }.to raise_error(RuntimeError, "ERROR: Unknown mode")
      end
    end
  end

  describe ".each_page" do
    let(:posts) { (1..25).to_a }

    it "ブロックなしで呼ぶとRuntimeErrorをraiseする" do
      expect { described_class.each_page(posts) }.to raise_error(RuntimeError, "ERROR")
    end

    it "各ページのpaginatorに正しい属性を渡し総ページ数を返す" do
      expect {|b| described_class.each_page(posts, nil, &b) }.to yield_successive_args(
        [[*1..10], have_attributes(page: 1, maxpage: 3)],
        [[*11..20], have_attributes(page: 2, maxpage: 3)],
        [[*21..25], have_attributes(page: 3, maxpage: 3)]
      )
    end

    context "prefixあり" do
      it "paginatorにprefixを渡す" do
        expect {|b| described_class.each_page(posts, "blog", &b) }.to yield_successive_args(
          [[*1..10], have_attributes(page: 1, maxpage: 3, prefix: "blog")],
          [[*11..20], have_attributes(page: 2, maxpage: 3, prefix: "blog")],
          [[*21..25], have_attributes(page: 3, maxpage: 3, prefix: "blog")]
        )
      end
    end

    context "prefixなし" do
      it "Paginatorにprefixキーを渡さない" do
        expect {|b| described_class.each_page([*1..10], nil, &b) }.to yield_successive_args(
          [[*1..10], have_attributes(page: 1, maxpage: 1)]
        )
      end
    end

    context "paginateがnil（デフォルト10）のとき" do
      before do
        allow(Simpress::Config.instance).to receive(:paginate).and_return(nil)
      end

      it "10件ずつに分割する" do
        expect {|b| described_class.each_page([*1..10], nil, &b) }.to yield_successive_args([[*1..10], anything])
      end
    end
  end

  describe ".uri" do
    it "Simpress::Uriインスタンスを返す" do
      expect(described_class.uri("/foo/bar")).to be_a(Simpress::Uri)
    end
  end

  describe ".build_context" do
    it "渡したキーワード引数をそのままHashで返す" do
      expect(described_class.build_context(title: "Hello", page: 1)).to eq({ title: "Hello", page: 1 })
    end
  end

  describe ".write_html" do
    before do
      allow(Simpress::Theme).to receive(:render).and_return("<html>content</html>")
      allow(Simpress::Writer).to receive(:write)
    end

    it "Theme.renderの結果をWriterに渡す" do
      context = { title: "Test" }
      described_class.write_html("/path", template: "my_template", context: context)
      expect(Simpress::Writer).to have_received(:write).with("/path.html", "<html>content</html>")
    end
  end

  describe ".write_json" do
    before do
      allow(Simpress::Writer).to receive(:write)
    end

    it "dump結果をWriterに渡す" do
      data = { key: "value" }
      described_class.write_json("/path", data)
      expect(Simpress::Writer).to have_received(:write).with("/path.json", Simpress::JSON.dump(data))
    end
  end

  describe ".write" do
    before do
      allow(Simpress::Writer).to receive(:write).and_yield("/output/post.html")
    end

    it "uriを経由してファイルパスを組み立てWriterに書き込みを依頼しブロックを呼ぶ" do
      expected_path = Simpress::Uri.wrap("/output/post").with_ext("html").build
      expect { |b| described_class.write("/output/post", "data", "html", &b) }.to yield_control
      expect(Simpress::Writer).to have_received(:write).with(expected_path, "data")
    end

    it "例外をraiseしない" do
      expect { described_class.write("/output/post", "data", "html") }.not_to raise_error
    end
  end
end
