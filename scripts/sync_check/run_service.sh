#!/bin/bash

set -e

## Ensure watchtower is running
docker stop watchtower 2> /dev/null || true
docker wait watchtower 2> /dev