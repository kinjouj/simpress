# frozen_string_literal: true

require "tmpdir"
require "simpress/plugin"
require "simpress/theme"

describe Simpress::Plugin do
  before do
    allow(Simpress::Logger).to receive(:debug)
  end

  after do
    described_class.clear
  end

  describe ".load" do
    let(:plugin_dir) do
      Dir.mktmpdir
    end

    let(:source) do
      <<~RUBY
        module Simpress
          module Plugin
            class Test1
              extend Simpress::Plugin

              def self.run(entries); end
            end
          end
        end
      RUBY
    end

    before do
      plugin_file = File.join(plugin_dir, "test1", "lib", "simpress", "plugin", "test1.rb")
      allow(Simpress::Config).to receive(:plugin_dir).and_return(plugin_dir)
      FileUtils.mkdir_p(File.dirname(plugin_file))
      File.write(plugin_file, source)
    end

    after do
      FileUtils.remove_entry(plugin_dir)
    end

    context "設定にあるプラグインの場合" do
      before do
        allow(Simpress::Config).to receive(:plugins).and_return(["test1"])
      end

      it "プラグインを登録する" do
        described_class.load

        expect(described_class.register_plugins.map(&:name)).to eq ["Simpress::Plugin::Test1"]
      end
    end

    context "設定にないプラグインの場合" do
      before do
        allow(Simpress::Config).to receive(:plugins).and_return([])
      end

      it "プラグインを登録しない" do
        described_class.load

        expect(described_class.register_plugins).to be_empty
      end
    end
  end

  describe ".register" do
    context "プラグインの場合" do
      it "プラグインを登録する" do
        klass = Class.new { extend Simpress::Plugin }
        described_class.register(klass)

        expect(described_class.register_plugins).to include(klass)
      end
    end

    context "Markdownフィルターの場合" do
      it "Markdownフィルターを登録する" do
        klass = Class.new { extend Simpress::Parser::Markdown::Filter }
        described_class.register(klass)

        expect(Simpress::Parser::Markdown::Filter.register_filters).to include(klass)
      end
    end

    context "Markdownフィルターを内包するプラグインの場合" do
      it "プラグインとMarkdownフィルターを登録する" do
        filter = Class.new { extend Simpress::Parser::Markdown::Filter }
        klass = Class.new { extend Simpress::Plugin }.tap {|plugin| plugin.const_set(:Filter, filter) }
        described_class.register(klass)

        expect(described_class.register_plugins).to include(klass)
        expect(Simpress::Parser::Markdown::Filter.register_filters).to include(filter)
      end
    end

    context "プラグインでもMarkdownフィルターでもない場合" do
      it "何も登録しない" do
        described_class.register(Class.new)

        expect(described_class.register_plugins).to be_empty
        expect(Simpress::Parser::Markdown::Filter.register_filters).to be_empty
      end
    end
  end

  describe ".clear" do
    it "Markdownフィルターも消す" do
      filter_class = Class.new { extend Simpress::Parser::Markdown::Filter }
      Simpress::Parser::Markdown::Filter.register_filters << filter_class
      described_class.clear

      expect(Simpress::Parser::Markdown::Filter.register_filters).to be_empty
    end
  end

  describe ".process" do
    context "プラグインが1つの場合" do
      before do
        test_plugin = Class.new { extend Simpress::Plugin }
        stub_const("Simpress::Plugin::Test", test_plugin)
        described_class.register_plugins << test_plugin
        allow(Simpress::Plugin::Test).to receive(:run)
      end

      it "プラグインを実行する" do
        described_class.process([])

        expect(Simpress::Plugin::Test).to have_received(:run)
      end
    end

    context "priorityが異なるプラグインの場合" do
      before do
        high_plugin = Class.new { extend Simpress::Plugin }
        high_plugin.define_singleton_method(:priority) { 10 }
        low_plugin = Class.new { extend Simpress::Plugin }
        low_plugin.define_singleton_method(:priority) { 1 }
        stub_const("Simpress::Plugin::High", high_plugin)
        stub_const("Simpress::Plugin::Low", low_plugin)
        described_class.register_plugins << low_plugin << high_plugin
        allow(Simpress::Plugin::High).to receive(:run)
        allow(Simpress::Plugin::Low).to receive(:run)
      end

      it "priorityの大きい順に実行する" do
        described_class.process([])

        expect(Simpress::Plugin::High).to have_received(:run).ordered
        expect(Simpress::Plugin::Low).to have_received(:run).ordered
      end
    end

    it "priorityが同じプラグインは登録順に実行する" do
      calls = []
      plugin_classes = Array.new(10) do |i|
        Class.new do
          extend Simpress::Plugin

          define_singleton_method(:run) {|_entries| calls << i }
        end
      end

      plugin_classes.each {|plugin| described_class.register_plugins << plugin }
      described_class.process([])

      expect(calls).to eq((0...10).to_a)
    end
  end

  describe "#bind_context" do
    it "コンテキストを更新する" do
      test_klass = Class.new { extend Simpress::Plugin }
      test_klass.bind_context(plugin_key: "value")

      expect(Simpress::Context[:plugin_key]).to eq "value"
    end
  end

  describe "#priority" do
    it "1を返す" do
      test_klass = Class.new { extend Simpress::Plugin }

      expect(test_klass.priority).to eq 1
    end
  end

  describe "#run" do
    it "NotImplementedErrorを発生させる" do
      test_klass = Class.new { extend Simpress::Plugin }

      expect { test_klass.run }.to raise_error(NotImplementedError)
    end
  end
end
