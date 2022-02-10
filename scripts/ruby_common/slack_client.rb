# frozen_string_literal: true

require 'slack-ruby-client'

# Wrapper Slack client class to handle sending messages and uploading logs.
class SlackClient
  @last_thread = nil
  @channel = nil
  @client = nil

  def initialize(channel, token)
    raise "Invalid channel name: #{channel}, must start with \#" un