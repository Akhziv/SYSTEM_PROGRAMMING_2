#!/bin/bash

set -e

## Ensure watchtower is running
docker stop watchtower 2> /dev/null || true
docker wait watchtower 2> /dev/null || true
docker run --rm \
    --detach \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name watchtower \
    containrrr/watchtower \
    --label-enable --include-stopped --revive-stopped --stop-timeout 120s --interval 600

# Clean volumes
rm -rf "${FORES