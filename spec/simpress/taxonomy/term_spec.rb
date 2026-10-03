# frozen_string_literal: true

require "simpress/taxonomy/term"

describe Simpress::Taxonomy::Term do
  let(:term_name) { "Ruby on Rails" }

  let(:term) do
    described_class.new(term_name)
  end

  describe "#initialize" do
    it "プロパティを設定する" do
      expect(term.key).to eq "ruby-on-rails"
      expect(term.name).to eq term_name
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

  describe "#as_json" do
    it "オプションが指定されない場合はデフォルトのキーを返す" do
      result = term.as_json
      expect(result.keys).to contain_exactly(:key, :name)
    end

    it "要求された許可済みキーを返す" do
      result = term.as_json(keys: [:key, :count])
      expect(result.keys).to contain_exactly(:key, :count)
    end

    it "同じオプションでchildrenに対して再帰的にas_jsonを呼び出す" do
      child_term = described_class.new("Child")
      term.children << child_term
      result = term.as_json(keys: [:children])
      expect(result[:children]).to eq [{ children: [] }]
    end
  end

  describe "#to_json" do
    it "Simpress::JSON.dumpに委譲する" do
      result = term.to_json
      expect(result).to eq '{"key":"ruby-on-rails","name":"Ruby on Rails"}'
    end
  end

  describe "#eql?" do
    it "相手のオブジェクトが同じkeyとnameを持つ場合はtrueを返す" do
      other = described_class.new(term_name)
      expect(term.eql?(other)).to be true
    end

    it "keyまたはnameが異なる場合はfalseを返す" do
      other = described_class.new("Other")
      expect(term.eql?(other)).to be false
    end

    it "相手のオブジェクトがTermでない場合はfalseを返す" do
      expect(term.eql?("string")).to be false
    end
  end
end
