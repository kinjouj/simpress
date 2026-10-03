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

      it "ディレクトリを作成してファイルパスにデータを書き込み、ブロックが渡された場合はファイルパスをyieldする" do
        expect {|b| described_class.write("test/index.html", "content", &b) }.to yield_with_args("public/test/index.html")
        expect(FileUtils).to have_received(:mkdir_p).with("public/test")
        expect(File).to have_received(:write).with("public/test/index.html", "content")
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
