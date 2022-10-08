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
    @logger.debug "Running `#{binary}` command with #{command}"
    stdout, stderr, status = Open3.capture3("docker run --entrypoint #{binary} \
                --init \
                --volume forest-data:#{FOREST_DATA} \
                --volume sync-check:#{FOREST_SCRIPTS} \
                --rm \
                ghcr.io/chainsafe/forest:#{FOREST_TAG} \
                --config #{FOREST_SCRIPTS}/sync_check.toml \
                #{command}")
    raise "Failed `#{binary} #{command}`.\n```\nSTDOUT:\n#{stdout}\nSTDERR:\n#{stderr}```" unless status.success?
  end

  # Runs a command for forest-cli. The configuration is pre-defined.
  def run_forest_cli(command)
    run_forest_container('forest-cli', command)
  end

  # Runs a command for forest node. The configuration is pre-defined.
  def run_forest(command)
    run_forest_container('forest', command)
  end

  # Gets current disk usage.
  def disk_us