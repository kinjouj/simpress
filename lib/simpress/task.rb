# frozen_string_literal: true

require "simpress/task/build"
require "simpress/task/server"

module Simpress
  class Task
    def self.register_tasks
      Simpress::Task::Build.new
      Simpress::Task::Server.new
    end
  end
end
