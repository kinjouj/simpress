# frozen_string_literal: true

require "simpress/theme/helper"

describe Simpress::Theme::Helper do
  let(:helper) do
    Class.new { include Simpress::Theme::Helper }.new
  end

  describe ".included" do
    context "モジュールにincludeした場合" do
      it "テーマのヘルパーとして使えるようにする" do
        Module.new do
          def test_helper
            "test_helper"
          end

          include Simpress::Theme::Helper
        end

        expect(Simpress::Theme.const_get(:Scope).new.test_helper).to eq "test_helper"
      end
    end
  end

  describe "#encode_json" do
    it "JSON文字列を返す" do
      data = { key: "value" }

      expect(helper.encode_json(data)).to eq '{"key":"value"}'
    end
  end

  describe "#absolute_url" do
    before do
      allow(Simpress::Config).to receive(:host).and_return("https://example.com")
    end

    it "ルートのパスから絶対URLを返す" do
      expect(helper.absolute_url("/")).to eq "https://example.com/"
    end

    it "ファイルのパスから絶対URLを返す" do
      expect(helper.absolute_url("/images/cover.webp")).to eq "https://example.com/images/cover.webp"
    end

    it "uriの結果から絶対URLを返す" do
      expect(helper.absolute_url(helper.uri("/entry-1"))).to eq "https://example.com/entry-1.html"
    end
  end

  describe "#uri" do
    it "パスをラップしてhtml拡張子を保証する" do
      expect(helper.uri("/test").to_s).to eq "/test.html"
    end
  end

  describe "#flatten_toc" do
    it "空のtocに対しては空配列を返す" do
      expect(helper.flatten_toc([])).to eq []
    end

    it "フラットな見出しリストにはdepth 0を割り当てる" do
      headings = [{ id: "section-1", text: "First", children: [] }]
      result = helper.flatten_toc(headings)

      expect(result).to eq [{ id: "section-1", text: "First", depth: 0 }]
    end

    it "兄弟の見出しを同じdepthで順序を保ったまま保持する" do
      headings = [{ id: "section-1", text: "First", children: [] }, { id: "section-2", text: "Second", children: [] }]
      result = helper.flatten_toc(headings)

      expect(result).to eq [{ id: "section-1", text: "First", depth: 0 }, { id: "section-2", text: "Second", depth: 0 }]
    end

    it "子を親の直後にdepthをインクリメントして配置する" do
      child = { id: "section-2", text: "Child" }
      parent = { id: "section-1", text: "Parent", children: [child] }
      result = helper.flatten_toc([parent])

      expect(result).to eq [{ id: "section-1", text: "Parent", depth: 0 }, { id: "section-2", text: "Child", depth: 1 }]
    end
  end
end
