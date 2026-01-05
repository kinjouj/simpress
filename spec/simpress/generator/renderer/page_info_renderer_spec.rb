# frozen_string_literal: true

require "simpress/generator/renderer/page_info_renderer"

describe Simpress::Generator::Renderer::PageInfoRenderer do
  before do
    allow(File).to receive(:exist?).and_return(false)
    allow(File).to receive(:write)
    allow(Simpress::Logger).to receive(:info)
  end

  it "正常にgenerate_jsonメソッドが呼ばれること" do
    expect { described_class.generate_json(10) }.not_to raise_error
    expect(File).to have_received(:write).with("public/pageinfo.json", { page: 10 }.to_json)
    expect(Simpress::Logger).to have_received(:info)
  end
end
