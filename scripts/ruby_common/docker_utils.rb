# frozen_string_literal: true

require 'docker'

# Tools to facilitate interacting with Docker
module DockerUtils
  # returns the specified container logs as String
  def self.get_container_logs(co