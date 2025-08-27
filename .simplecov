# frozen_string_literal: true

SimpleCov.refuse_coverage_drop
SimpleCov.start do
  add_filter "/spec/"
  enable_coverage :branch
end
