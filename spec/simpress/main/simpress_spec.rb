# frozen_string_literal: true

require "simpress"

describe Simpress do
  before do
    allow(Simpress::Logger).to receive(:info)
    allow(Simpress::Logger).to receive(:debug)
    allow(Simpress::Config.instance).to receive(:mode).and_return(:html)
    allow(Simpress::Config.instance).to receive(:plugins).and_return(["sample"])
    allow(Simpress::Config.instance).to receive(:output_dir).and_return(create_filepath("public"))
    allow(Simpress::Theme).to receive(:theme_dir).and_return(create_filepath("theme"))
    allow(Simpress::Generator).to receive(:source_dir).and_return(create_filepath("source"))
    allow(Simpress::Plugin).to receive(:plugin_dir).and_return(create_filepath("plugins"))
    allow(Simpress::Paginator).to receive(:paginate).and_return(1)
  end

  after do
    Dir.glob(create_filepath("public/*")) {|file| FileUtils.rm_rf(file) }
  end

  it do
    expect { described_class.build }.not_to raise_error
    expect(Simpress::Logger).to have_received(:info).at_least(1).times
    expect(Simpress::Logger).to have_received(:debug).exactly(1).times
    expect(File).to exist(create_filepath("public/count.txt"))
    expect(File).to exist(create_filepath("public/test.html"))
    expect(File).to exist(create_filepath("public/test2.html"))
    expect(File).to exist(create_filepath("public/index.html"))
    expect(File).to exist(create_filepath("public/archives/page/2.html"))
    expect(File).to exist(create_filepath("public/archives/2000/01/index.html"))
    expect(File).to exist(create_filepath("public/archives/2000/01/2.html"))
    expect(File).to exist(create_filepath("public/archives/category/test/index.html"))
    expect(File).to exist(create_filepath("public/archives/category/test/2.html"))
  end
end
