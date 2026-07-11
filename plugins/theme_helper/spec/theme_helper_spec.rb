# frozen_string_literal: true

require "simpress/plugin/theme_helper"

describe Simpress::Plugin::ThemeHelper do # rubocop:disable RSpec/EmptyExampleGroup
  let(:helper_test_class) do
    Class.new do
      include Simpress::Plugin::ThemeHelper
    end
  end

  let(:helper) do
    helper_test_class.new
  end
end
