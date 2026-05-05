# frozen_string_literal: true

require "simpress/generator/renderer/base_renderer"

describe Simpress::Generator::Renderer::BaseRenderer do
  before do
    allow(Simpress::Config.instance).to receive(:mode).and_return("html")
    allow(Simpress::Writer).to receive(:write)
    allow(Simpress::Theme).to receive(:render).and_return("<html></html>")
    allow(Simpress::JSON).to receive(:dump).and_return('{"json":true}')
  end

  describe ".generate" do
    it "calls generate_html when mode is html" do
      allow(described_class).to receive(:generate_html)
      described_class.generate(:arg)
      expect(described_class).to have_received(:generate_html).with(:arg)
    end

    it "calls generate_json when mode is json" do
      allow(Simpress::Config.instance).to receive(:mode).and_return("json")
      allow(described_class).to receive(:generate_json)
      described_class.generate(:arg)
      expect(described_class).to have_received(:generate_json).with(:arg)
    end

    it "raises error for unknown mode" do
      allow(Simpress::Config.instance).to receive(:mode).and_return("unknown")
      expect { described_class.generate }.to raise_error("ERROR: Unknown mode")
    end
  end

  describe ".each_page" do
    before do
      allow(Simpress::Config.instance).to receive(:paginate).and_return(2)
    end

    it "raises error if block is not given" do
      expect { described_class.each_page([]) }.to raise_error("ERROR")
    end

    it "slices posts and yields paginator" do
      expect {|b| described_class.each_page([1, 2, 3], "blog", &b) }.to yield_successive_args(
        [[1, 2], have_attributes(page: 1)],
        [[3], have_attributes(page: 2)]
      )
    end

    it "returns the total page size" do
      result = described_class.each_page(Array.new(11)) {} # rubocop:disable Lint/EmptyBlock
      expect(result).to eq 6
    end
  end

  describe ".uri" do
    it "returns a Simpress::Uri object" do
      result = described_class.uri("test")
      expect(result).to be_a(Simpress::Uri)
      expect(result.to_s).to eq "test"
    end
  end

  describe ".write_html" do
    it "renders template and writes with html extension" do
      context = { posts: [] }
      described_class.write_html("index", template: "layout", **context)
      expect(Simpress::Theme).to have_received(:render).with("layout", **context)
      expect(Simpress::Writer).to have_received(:write).with("index.html", "<html></html>")
    end
  end

  describe ".write_json" do
    it "dumps data and writes with json extension" do
      data = { key: "value" }
      described_class.write_json("api/data", data)
      expect(Simpress::JSON).to have_received(:dump).with(data)
      expect(Simpress::Writer).to have_received(:write).with("api/data.json", '{"json":true}')
    end
  end

  describe ".write" do
    before do
      allow(Simpress::Writer).to receive(:write) {|path, _data, &block| block&.call(path) }
    end

    it "builds the path with extension and calls Simpress::Writer" do
      expect { described_class.write("file", "content", "txt") }.not_to raise_error
      expect(Simpress::Writer).to have_received(:write).with("file.txt", "content")
    end

    it "yields the file path to the block" do
      expect {|b| described_class.write("file", "content", "txt", &b) }.to yield_with_args("file.txt")
    end
  end
end
