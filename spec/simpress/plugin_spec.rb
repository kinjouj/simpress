# frozen_string_literal: true

require "simpress/plugin"

describe Simpress::Plugin do
  before do
    allow(Simpress::Config).to receive(:plugin_dir).and_return("plugins")
    allow(Simpress::Config.instance).to receive(:plugins).and_return([])
    allow(Simpress::Logger).to receive(:debug)
  end

  after do
    described_class.clear
  end

  describe ".load" do
    let(:plugin_path) { "plugins/test_plugin/lib/simpress/plugin/test_plugin.rb" }

    before do
      allow(Dir).to receive(:[]).and_return([plugin_path])
      allow(Kernel).to receive(:load).with(plugin_path)
    end

    it "loads plugin files from the plugin directory" do
      described_class.load
      expect(Kernel).to have_received(:load).with(plugin_path)
    end
  end

  describe ".process" do
    before do
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["Test"])
    end

    it "executes the run method for plugins listed in config" do
      test_plugin = Class.new do
        extend Simpress::Plugin

        def self.run(posts, pages)
          # TEST
        end
      end

      stub_const("Simpress::Plugin::Test", test_plugin)
      allow(Simpress::Plugin::Test).to receive(:run)
      described_class.process([], [])
      expect(Simpress::Plugin::Test).to have_received(:run)
    end

    it "executes plugins in descending order of priority" do
      high_plugin = Class.new do
        extend Simpress::Plugin

        def self.priority
          10
        end

        def self.run(posts, pages)
          # TEST
        end
      end

      low_plugin = Class.new do
        extend Simpress::Plugin

        def self.priority
          1
        end

        def self.run(posts, pages)
          # TEST
        end
      end

      stub_const("Simpress::Plugin::High", high_plugin)
      stub_const("Simpress::Plugin::Low", low_plugin)
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["High", "Low"])
      allow(Simpress::Plugin::High).to receive(:run)
      allow(Simpress::Plugin::Low).to receive(:run)
      described_class.process([], [])
      expect(Simpress::Plugin::High).to have_received(:run).ordered
      expect(Simpress::Plugin::Low).to have_received(:run).ordered
    end
  end

  describe "#config" do
    it "returns the singleton config instance" do
      test_klass = Class.new { extend Simpress::Plugin }
      expect(test_klass.config).to eq Simpress::Config.instance
    end
  end

  describe "#bind_context" do
    it "updates the Simpress::Context data" do
      test_klass = Class.new { extend Simpress::Plugin }
      test_klass.bind_context(plugin_key: "value")
      expect(Simpress::Context[:plugin_key]).to eq "value"
    end
  end

  describe "#priority" do
    it "returns the default value of 1" do
      test_klass = Class.new { extend Simpress::Plugin }
      expect(test_klass.priority).to eq 1
    end
  end

  describe "#run" do
    before do
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["Test"])
    end

    it "raises NotImplementedError" do
      Class.new do
        extend Simpress::Plugin

        def self.name
          "Test"
        end
      end

      expect { described_class.process([], []) }.to raise_error(NotImplementedError)
    end
  end
end
