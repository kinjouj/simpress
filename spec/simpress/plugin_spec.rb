# frozen_string_literal: true

require "tmpdir"
require "simpress/plugin"

describe Simpress::Plugin do
  let(:plugin_dir) { Dir.mktmpdir }

  before do
    allow(Simpress::Config).to receive(:plugin_dir).and_return(plugin_dir)
    allow(Simpress::Config.instance).to receive(:plugins).and_return([])
    allow(Simpress::Logger).to receive(:debug)
  end

  after do
    described_class.clear
    FileUtils.remove_entry(plugin_dir)
  end

  def write_plugin_file(dir_name, file_name, class_name, content = nil)
    path = File.join(plugin_dir, dir_name, "lib", "simpress", "plugin", "#{file_name}.rb")
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content || <<~RUBY)
      module Simpress
        module Plugin
          class #{class_name}
            extend Simpress::Plugin

            def self.run(posts, pages); end
          end
        end
      end
    RUBY
  end

  describe ".load" do
    it "registers a plugin class whose underscored name is listed in config" do
      write_plugin_file("test1", "test1", "Test1")
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["test1"])

      described_class.load

      expect(described_class.register_plugins.map(&:name)).to eq ["Simpress::Plugin::Test1"]
    end

    it "does not register a plugin class that is not listed in config" do
      write_plugin_file("test2", "test2", "Test2")
      allow(Simpress::Config.instance).to receive(:plugins).and_return([])

      described_class.load

      expect(described_class.register_plugins).to be_empty
    end

    it "loads plugins from multiple plugin directories" do
      write_plugin_file("test3", "test3", "Test3")
      write_plugin_file("test4", "test4", "Test4")
      allow(Simpress::Config.instance).to receive(:plugins).and_return(["test3", "test4"])

      described_class.load

      names = described_class.register_plugins.map(&:name)
      expect(names).to include("Simpress::Plugin::Test3", "Simpress::Plugin::Test4")
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
      described_class.register_plugins << test_plugin
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
      described_class.register_plugins << low_plugin << high_plugin
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
    it "raises NotImplementedError" do
      test_klass = Class.new { extend Simpress::Plugin }
      expect { test_klass.run }.to raise_error(NotImplementedError)
    end
  end
end
