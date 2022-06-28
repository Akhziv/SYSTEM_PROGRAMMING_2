
# frozen_string_literal: true

require 'cs_utils/slack_client'
require 'cs_utils/docker_utils'
require 'logger'
require 'fileutils'

# Retrieves an environmental variable, failing if its not set or empty.
def get_and_assert_env_variable(name)
  var = ENV[name]
  raise "Please set #{name} environmental variable" if var.nil? || var.empty?

  var
end
