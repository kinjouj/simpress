# frozen_string_literal: true

require "simpress/theme"

describe Simpress::Theme do
  before do
    described_class.clear
    allow(Simpress::Config).to receive(:theme_dir).and_return("spec/fixtures/theme")
  end

  after do
    described_class.clear
  end

  let(:tilt_template) { instance_double(Tilt::ErubiTemplate) }

  describe ".render" do
    before do
      allow(Simpress::Context).to receive(:to_h).and_return({ site_title: "My Blog" })
      allow(Tilt::ErubiTemplate).to receive(:new).with("spec/fixtures/theme/layout.erb", escape: true).and_return(tilt_template)
      allow(tilt_template).to receive(:render).and_return("<html>My Blog</html>")
    end

    it "initializes the template with the correct path" do
      described_class.render("layout", { page_title: "Post" })
      expect(Tilt::ErubiTemplate).to have_received(:new).with("spec/fixtures/theme/layout.erb", escape: true)
    end

    it "returns the rendered result" do
      expect(described_class.render("layout", { page_title: "Post" })).to eq "<html>My Blog</html>"
    end
  end

  describe ".render_partial" do
    before do
      allow(Tilt::ErubiTemplate).to receive(:new).with("spec/fixtures/theme/part.erb", escape: true).and_return(tilt_template)
      allow(tilt_template).to receive(:render).and_return("<div>partial</div>")
    end

    it "returns the rendered result" do
      expect(described_class.render_partial("part", { item: "value" })).to eq "<div>partial</div>"
    end
  end

  describe ".clear" do
    before do
      allow(Tilt::ErubiTemplate).to receive(:new).and_return(tilt_template)
      allow(tilt_template).to receive(:render).and_return("content")
    end

    it "resets the tilt caches" do
      described_class.render("test", {})
      described_class.clear
      described_class.render("test", {})
      expect(Tilt::ErubiTemplate).to have_received(:new).twice
    end
  end
end
