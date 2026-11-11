# frozen_string_literal: true

require "simpress/taxonomy/term"

describe Simpress::Taxonomy::Term do
  let(:term) do
    described_class.new("Ruby on Rails")
  end

  describe "#initialize" do
    it "プロパティを設定する" do
      expect(term.key).to eq "ruby-on-rails"
      expect(term.name).to eq "Ruby on Rails"
      expect(term.entries).to eq []
      expect(term.children).to eq []
    end
  end

  describe "#initialize_copy" do
    it "children配列をディープコピーする" do
      child_term = described_class.new("Child")
      term.children << child_term
      copy = term.dup

      expect(copy.children.first).not_to equal(child_term)
      expect(copy.children.first.name).to eq "Child"
    end
  end

  describe "#count" do
    before do
      allow(term.entries).to receive(:size).and_return(5)
    end

    it "関連付けられたエントリの数を返す" do
      expect(term.count).to eq 5
    end
  end

  describe "#to_h" do
    context "オプションが指定されない場合" do
      it "デフォルトのキーを返す" do
        result = term.to_h

        expect(result.keys).to contain_exactly(:key, :name)
      end
    end

    context "許可済みキーが指定された場合" do
      it "要求されたキーを返す" do
        result = term.to_h(keys: [:key, :count])

        expect(result.keys).to contain_exactly(:key, :count)
      end
    end

    context "childrenを持つ場合" do
      let(:child_term) do
        described_class.new("Child")
      end

      before do
        term.children << child_term
      end

      it "childrenもハッシュに変換して返す" do
        result = term.to_h(keys: [:name, :children])

        expect(result[:children]).to eq [{ name: "Child", children: [] }]
      end
    end
  end

  describe "#to_json" do
    it "keyとnameのJSON文字列を返す" do
      result = term.to_json

      expect(result).to eq '{"key":"ruby-on-rails","name":"Ruby on Rails"}'
    end
  end

  describe "#eql?" do
    context "同じkeyとnameを持つTermの場合" do
      let(:other) do
        described_class.new("Ruby on Rails")
      end

      it "trueを返す" do
        expect(term.eql?(other)).to be true
      end
    end

    context "keyまたはnameが異なる場合" do
      let(:other) do
        described_class.new("Other")
      end

      it "falseを返す" do
        expect(term.eql?(other)).to be false
      end
    end

    context "Termではない場合" do
      it "falseを返す" do
        expect(term.eql?("string")).to be false
      end
    end
  end
end
