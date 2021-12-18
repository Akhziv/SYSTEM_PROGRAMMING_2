# frozen_string_literal: true

require 'date'
require 'pathname'

# Class representing a snapshot bucket with a defined number of entries.
class SnapshotBucket
  def initialize(max_entries = nil)
    @max_entries = max_entries
    @entries = Set.new
  end

  # Adds an entry to the bucket unless it is already full or already contains the key.
  # Return false on insert failure.
  def add?(entry)
    return false if !@max_entries.nil? && @entries.size >= @max_entries

    !@entries.add?(entry).nil?
  end
end

# Represents Day Bucket. They key is the date.
class DayBucket < SnapshotBucket
  def add?(entry)
    super File.mtime(entry).to_date
  end
end

# Represents Weeks Bucket. The key is "WWYY" (week starts on Monday).
class WeeksBucket < SnapshotBucket
  def add?(entry)
    super File.mtime(entry).to_date.strftime('%m%y')
  end
end

# Represents Months Bucket. The key is "MMYY"
class MonthsBu