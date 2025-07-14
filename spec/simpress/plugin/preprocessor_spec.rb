# frozen_string_literal: true

require "simpress/config"
require "simpress/context"
require "simpress/plugin"
require "simpress/plugin/preprocessor"
require "simpress/plugin/preprocessor/hostname"
require "simpress/logger"

describe Simpress::Plugin::Preprocessor do
  after do
    Simpress::Plugin::Preprocessor.finish
  end

  it "test1" do
    expect(Simpress::Logger).to receive(:debug).exactly(2)
    allow(Simpress::Config.instance).to receive(:preprocessors).and_return(%w[test1_preprocessor hostname])

    module Simpress
      module Plugin
        module Preprocessor
          class Test1Preprocessor
            extend Simpress::Plugin::Preprocessor

            def self.run(*_args)
              register_context(mode: config.mode)
            end
          end
        end
      end
    end

    module Simpress
      module Plugin
        module Preprocessor
          class HogePreprocessor
            extend Simpress::Plugin::Preprocessor

            def self.run(*_args)
              register_context(msg: "hoge")
            end
          end
        end
      end
    end

    Simpress::Plugin::Preprocessor.process
    expect(Simpress::Context[:mode]).to eq("html")
    expect { Simpress::Context[:msg] }.to raise_error("msg missing")
  end

  it "test2" do
    expect(Simpress::Logger).to receive(:debug).once
    allow(Simpress::Config.instance).to receive(:preprocessors).and_return(["test2_plugin"])

    module Simpress
      module Plugin
        module Preprocessor
          class Test2Plugin
            extend Simpress::Plugin::Preprocessor
          end
        end
      end
    end

    expect { Simpress::Plugin::Preprocessor.process }.to raise_error(RuntimeError)
  end

  it "test3" do
    allow(Simpress::Config.instance).to receive(:preprocessors).and_return([[]])

    expect { Simpress::Plugin::Preprocessor.process }.not_to raise_error
  end
end
