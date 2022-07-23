# frozen_string_literal: true

require_relative 'ruby_common/slack_client'
require_relative 'ruby_common/utils'

require 'English'
require 'fileutils'
require 'sys/filesystem'
require 'logger'
require 'open3'

SLACK_TOKEN = ge