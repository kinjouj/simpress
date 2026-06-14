# frozen_string_literal: true

require "simpress/taxonomy/term"

describe Simpress::Taxonomy::Term do
  let(:term_name) do
    "Ruby on Rails"
  end

  let(:term) do
    described_class.new(term_name)
  end

  describe "#initialize" do
    it "assigns properties" do
      expect(term.key).to eq "ruby-on-rails"
      expect(term.name).to eq term_name
      expect(term.posts).to eq []
      expect(term.children).to eq []
    end
  end

  describe "#initialize_copy" do
    it "performs a deep copy of the children array" do
      child_term = described_class.new("Child")
      term.children << child_term
      copy = term.dup
      expect(copy.children.first).not_to equal(child_term)
      expect(copy.children.first.name).to eq "Child"
    end
  end

  describe "#count" do
    before do
      allow(term.posts).to receive(:size).and_return(5)
    end

    it "returns the number of associated posts" do
      expect(term.count).to eq 5
    end
  end

  describe "#as_json" do
    it "returns default keys when no options are provided" do
      result = term.as_json
      expect(result.keys).to contain_exactly(:key, :name)
    end

    it "returns requested permitted keys" do
      result = term.as_json(keys: [:key, :count])
      expect(result.keys).to contain_exactly(:key, :count)
    end

    it "recursively calls as_json on children with the same options" do
      child_term = described_class.new("Child")
      term.children << child_term
      result = term.as_json(keys: [:children])
      expect(result[:children]).to eq [{ children: [] }]
    end
  end

  describe "#to_json" do
    it "delegates to Simpress::JSON.dump" do
      result = term.to_json
      expect(result).to eq '{"key":"ruby-on-rails","name":"Ruby on Rails"}'
    end
  end

  describe "#eql?" do
    it "returns true if the other object has the same key and name" do
      other = described_class.new(term_name)
      expect(term.eql?(other)).to be true
    end

    it "returns false if the key or name differs" do
      other = described_class.new("Other")
      expect(term.eql?(other)).to be false
    end

    it "returns false if the other object is not a Term" do
      expect(term.eql?("string")).to be false
    end
  end
end
