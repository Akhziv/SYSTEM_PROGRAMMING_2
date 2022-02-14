# frozen_string_literal: true

require 'slack-ruby-client'

# Wrapper Slack client class to handle sending messages and uploading logs.
class SlackClient
  @last_thread = nil
  @channel = nil
  @client = nil

  def initialize(channel, token)
    raise "Invalid channel name: #{channel}, must start with \#" unless channel.start_with? '#'
    raise 'Missing token' if token.nil?

    Slack.configure do |config|
      config.token = token
    end

    @channel = channel
    @client = Slack::Web::Client.new
  end

  # Posts a new message to configured channel.
  def post_message(text)
    msg = @client.chat_postMessage(channel: @channel, text: text)
    