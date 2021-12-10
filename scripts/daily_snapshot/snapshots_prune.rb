# frozen_string_literal: true

require 'date'
require 'pathname'

# Class representing a snapshot bucket with a defined number of entries.
class SnapshotBucket
  def initialize(max_entries = nil)
    @max_entries = max_entries
    @entries = Set.new
  end

  # Adds an entry to the bucket unless it is already full or already contains 