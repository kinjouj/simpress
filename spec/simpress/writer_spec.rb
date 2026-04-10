# frozen_string_literal: true

require "simpress/writer"

describe Simpress::Writer do
  describe ".write" do
    context "when the file does not exist" do
      before do
        allow(File).to receive(:exist?).with("public/test/index.html").and_return(false)
        allow(File).to receive(:dirname).with("public/test/index.html").and_return("public/test")
        allow(FileUtils).to receive(:mkdir_p).with("public/test")
        allow(File).to receive(:write).with("public/test/index.html", "content")
      end

      it "creates the directory" do
        described_class.write("test/index.html", "content")
        expect(FileUtils).to have_received(:mkdir_p).with("public/test")
      end

      it "writes data to the filepath" do
        described_class.write("test/index.html", "content")
        expect(File).to have_received(:write).with("public/test/index.html", "content")
      end

      it "yields the filepath if a block is given" do
        expect {|b| described_class.write("test/index.html", "content", &b) }.to yield_with_args("public/test/index.html")
      end
    end

    context "when the file already exists" do
      before do
        allow(File).to receive(:exist?).with("public/exists.txt").and_return(true)
      end

      it "raises an error" do
        expect { described_class.write("exists.txt", "data") }.to raise_error("FILE EXISTS: public/exists.txt")
      end
    end
  end
end
