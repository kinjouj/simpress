# frozen_string_literal: true

notification :off

guard "rake", task: :build, run_on_start: false, all_after_pass: false do
  watch(%r{^themes/(.+)})
  watch(%r{^static/(.+)})
  watch(%r{^source/(.+)})
  watch(%r{^scss/(.+)})
end
