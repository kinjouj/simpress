# frozen_string_literal: true

require "simpress/writer"

describe Simpress::Writer do
  describe ".write" do
    context "ファイルが存在しない場合" do
      before do
        allow(File).to receive(:exist?).with("public/test/index.html").and_return(false)
        allow(File).to receive(:dirname).with("public/test/index.html").and_return("public/test")
        allow(FileUtils).to receive(:mkdir_p).with("public/test")
        allow(File).to receive(:write).with("public/test/index.html", "content")
      end

      it "ディレクトリを作成する" do
        described_class.write("test/index.html", "content")
        expect(FileUtils).to have_received(:mkdir_p).with("public/test")
      end

      it "ファイルパスにデータを書き込む" do
        described_class.write("test/index.html", "content")
        expect(File).to have_received(:write).with("public/test/index.html", "content")
      end

      it "ブロックが渡された場合はファイルパスをyieldする" do
        expect {|b| described_class.write("test/index.html", "content", &b) }.to yield_with_args("public/test/index.html")
      end
    end

    context "ファイルが既に存在する場合" do
      before do
        allow(File).to receive(:exist?).with("public/exists.txt").and_return(true)
      end

      it "エラーを発生させる" do
        expect { described_class.write("exists.txt", "data") }.to raise_error("FILE EXISTS: public/exists.txt")
      end
    end
  end
end
