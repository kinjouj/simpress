# frozen_string_literal: true

require "psych"

module FixtureHelper
  def load_fixture(file)
    data = Psych.load_file(File.join("spec/fixture", file), permitted_classes: [Time, Symbol], symbolize_names: true)
    data[:categories].map! {|category| Simpress::Category.fetch(category) }

    Simpress::Post.new(data)
  end
end
