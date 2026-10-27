# frozen_string_literal: true

require "simpress/generator/pipeline/base"

module Simpress
  module Generator
    module Pipeline
      module Archive
        class Base < Simpress::Generator::Pipeline::Base
          DATA_JSON_KEYS = [:id, :title, :date, :permalink, :taxonomies, :cover, :description].freeze
        end
      end
    end
  end
end
