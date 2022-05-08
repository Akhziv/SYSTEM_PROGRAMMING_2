
#!/usr/bin/env bash

# Script to check health status of a running node.
# The only prerequisite here is that the `forest` process is running.
# The script will wait till metrics endpoint becomes available.
# Input: Forest hostname

# Exit codes
RET_OK=0
RET_SYNC_TIPSET_STALE=1
RET_SYNC_ERROR=2
RET_SYNC_TIMEOUT=3
RET_HOSTNAME_NOT_SET=4

if [ $# -eq 0 ]; then
    echo "No arguments supplied. Need to provide Forest hostname, e.g. forest-mainnet."
    exit "$RET_HOSTNAME_NOT_SET"
fi

# Governs how long the health check will run to assert Forest condition
HEALTH_CHECK_DURATION_SECONDS=${HEALTH_CHECK_DURATION_SECONDS:-"360"}
# Forest metrics endpoint path
FOREST_METRICS_ENDPOINT=${FOREST_METRICS_ENDPOINT:-"http://$1:6116/metrics"}
# Initial sync timeout (in seconds) after which the health check will fail
HEALTH_CHECK_SYNC_TIMEOUT_SECONDS=${HEALTH_CHECK_SYNC_TIMEOUT_SECONDS:-"7200"}

# Extracts metric value from the metric data
# Arg: name of the metric
function get_metric_value() {
  grep -E "^$1" <<< "$metrics" | cut -d' ' -f2
}

# Updates metrics data with the latest metrics from Prometheus
# Arg: none
function update_metrics() {
  metrics=$(curl --silent "$FOREST_METRICS_ENDPOINT")
}

# Checks if an error occurred and is visible in the metrics.
# Arg: name of the error metric
function assert_error() {
  errors="$(get_metric_value "$1")"
  if [ -n "$errors" ]; then
    echo "❌ $1: $errors"
    ret=$RET_SYNC_ERROR
  fi
}

##### Actual script

# Wait for Forest to start syncing
timeout="$HEALTH_CHECK_SYNC_TIMEOUT_SECONDS"
echo "⏳ Waiting for Forest to start syncing (up to $timeout seconds)..."
until [ -n "$tipset_start" ] || [ "$timeout" -le 0 ]
do
  update_metrics
  tipset_start="$(get_metric_value "last_validated_tipset_epoch")"
  sleep 1
  timeout=$((timeout-1))
done

if [ "$timeout" -le 0 ]; then