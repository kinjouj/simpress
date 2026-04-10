# frozen_string_literal: true

require "simpress/config"

describe Simpress::Config do
  let(:config_data) do
    {
      default: {
        mode: "html",
        host: "https://example.com",
        logging: true,
        paginate: 10,
        plugins: ["test_plugin"]
      }
    }
  end

  let(:taxonomies) do
    { "categories" => { "Ruby" => "ruby" }, "tags" => {} }
  end

  before do
    allow(Psych).to receive(:load_file).with(Simpress::Config::CONFIG_FILE, any_args).and_return(config_data)
    allow(File).to receive(:exist?).with(Simpress::Config::TAXONOMIES_FILE).and_return(true)
    allow(Psych).to receive(:load_file).with(Simpress::Config::TAXONOMIES_FILE).and_return(taxonomies)
  end

  after do
    described_class.clear
  end

  describe ".instance" do
    it "loads the config file" do
      config = described_class.instance
      expect(config.mode).to eq "html"
      expect(config.host).to eq "https://example.com"
      expect(config.logging).to be true
      expect(config.paginate).to eq 10
      expect(config.plugins).to eq ["test_plugin"]
    end

    it "loads taxonomies from taxonomies.yaml" do
      expect(described_class.instance.taxonomies).to eq taxonomies
    end
  end

  describe ".clear" do
    it "resets the singleton so the next call returns a new instance" do
      obj = described_class.instance
      described_class.clear
      expect(obj).not_to be described_class.instance
    end
  end

  describe "#taxonomies" do
    context "when taxonomies.yaml does not exist" do
      before do
        allow(File).to receive(:exist?).with(Simpress::Config::TAXONOMIES_FILE).and_return(false)
      end

      it "returns empty hash" do
        expect(described_class.instance.taxonomies).to eq({})
      end
    end

    context "when taxonomies.yaml is empty" do
      before do
        allow(Psych).to receive(:load_file).with(Simpress::Config::TAXONOMIES_FILE).and_return(nil)
      end

      it "returns empty hash" do
        expect(described_class.instance.taxonomies).to eq({})
      end
    end
  end
end
