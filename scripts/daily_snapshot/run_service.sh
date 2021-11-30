#!/bin/bash

set -e

S3_FOLDER=$BASE_FOLDER/s3

# 1. Setup s3fs to get the snapshots.
# 2. Make sure an instance of watchtower is running.
# 3. Run Ruby script for exporting and uploading a new snapshot
#    i