# frozen_string_literal: true

SimpleCov.configure do
  skip "/spec/"
  enable_coverage :branch
  merge_timeout 3600
end
