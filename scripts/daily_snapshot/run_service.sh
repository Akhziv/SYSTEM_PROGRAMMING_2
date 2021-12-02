#!/bin/bash

set -e

S3_FOLDER=$BASE_FOLDER/s3

# 1. Setup s3fs to get the snapshots.
# 2. Make sure an instance of watchtower is running.
# 3. Run Ruby script for exporting and uploading a new snapshot
#    if there isn't one for today already.

## Setup s3
umount "$S3_FOLDER" || true
mkdir --parents "$S3_FOLDER"

s3fs forest-snapshots "$S3_FOLDER" \
    -o default_acl=public-read \
    -o url=https://fra1.digitaloceanspaces.com/ \
    -