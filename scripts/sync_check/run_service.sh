#!/bin/bash

set -e

## Ensure watchtower is running
docker stop watchtower 2> /dev/null || true
docker wait watchtower 2> /dev/null || true
docker run --rm \
    --detach \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name