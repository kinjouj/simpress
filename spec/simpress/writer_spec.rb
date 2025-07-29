# frozen_string_literal: true

require "simpress/config"
require "simpress/writer"

describe Simpress::Writer do
  before do
    stub_const("Simpress::Writer::OUTPUT_DIR", create_filepath("."))
  end

  after do
    Dir[create_filepath("./*.txt")].each {|file| FileUtils.rm_rf(file) }
  end

  context "#write" do
    it "successful" do
      Simpress::Writer.write("./test.txt", "hoge")
      expect(File).to exist(create_filepath("./test.txt"))
    end

    it "既に存在するファイルに書き込みしようとした場合" do
      Simpress::Writer.write("./test.txt", "hoge")
      expect(File).to exist(create_filepath("./test.txt"))
      expect { Simpress::Writer.write("./test.txt", "hoge") }.to raise_error(RuntimeError)
    end

    it "blockを要求した場合" do
      Simpress::Writer.write("./test.txt", "hoge") do |filepath|
        expect(filepath).to eq(create_filepath("./test.txt"))
      end
    end
  end
end
