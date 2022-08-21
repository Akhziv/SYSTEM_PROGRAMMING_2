# frozen_string_literal: true

require_relative 'ruby_common/slack_client'
require_relative 'ruby_common/utils'

require 'English'
require 'fileutils'
require 'sys/filesystem'
require 'logger'
require 'open3'

SLACK_TOKEN = get_and_assert_env_variable 'FOREST_SLACK_API_TOKEN'
CHANNEL = get_and_assert_env_variable 'FOREST_SLACK_NOTIF_CHANNEL'
FOREST_DATA = get_and_assert_env_variable 'FOREST_TARGET_DATA'
FOREST_SCRIPTS = get_and_assert_env_variable 'FOREST_TARGET_SCRIPTS'
FOREST_TAG = get_and_assert_env_variable 'FOREST_TAG'

# Sync check class encompassing all required methods and fields
class SyncCheck
  def initialize
    @logger = Logger.new($stdout)
    @client = SlackClient.new CHANNEL, SLACK_TOKEN
  end

  # Runs a command with an arbitrary binary available in the chainsafe/forest image
  def run_forest_container(binary, command)
    @logger.debug "Running `#{binary}