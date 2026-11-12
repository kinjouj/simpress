# frozen_string_literal: true

require "simpress/taxonomy/term"

describe Simpress::Taxonomy::Term do
  let(:term) do
    described_class.new("Ruby on Rails")
  end

  describe "#initialize" do
    it "sets the properties" do
      expect(term.key).to eq "ruby-on-rails"
      expect(term.name).to eq "Ruby on Rails"
      expect(term.entries).to eq []
      expect(term.children).to eq []
    end
  end

  describe "#initialize_copy" do
    it "deep copies the children array" do
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

    it "returns the entry count" do
      expect(term.count).to eq 5
    end
  end

  describe "#to_h" do
    context "when no options are given" do
      it "returns the default keys" do
        result = term.to_h

        expect(result.keys).to contain_exactly(:key, :name)
      end
    end

    context "when allowed keys are given" do
      it "returns the requested keys" do
        result = term.to_h(keys: [:key, :count])

        expect(result.keys).to contain_exactly(:key, :count)
      end
    end

    context "when children exist" do
      let(:child_term) do
        described_class.new("Child")
      end

      before do
        term.children << child_term
      end

      it "converts children to hashes" do
        result = term.to_h(keys: [:name, :children])

        expect(result[:children]).to eq [{ name: "Child", children: [] }]
      end
    end
  end

  describe "#to_json" do
    it "returns key and name JSON" do
      result = term.to_json

      expect(result).to eq '{"key":"ruby-on-rails","name":"Ruby on Rails"}'
    end
  end

  describe "#eql?" do
    context "when key and name match" do
      let(:other) do
        described_class.new("Ruby on Rails")
      end

      it "returns true" do
        expect(term.eql?(other)).to be true
      end
    end

    context "when key or name differs" do
      let(:other) do
        described_class.new("Other")
      end

      it "returns false" do
        expect(term.eql?(other)).to be false
      end
    end

    context "when not a Term" do
      it "returns false" do
        expect(term.eql?("string")).to be false
      end
    end
  end
end
