#!/bin/bash

# The .env file contains environment variables that we want access to.
set -o allexport
# Trust that the `.env` exists in the CWD during the script execution.
# shellcheck disable=SC1091
source .env
set +o allexport

error=0

# Check if an environment variable is set. If it isn't, set error=1.
check_env () {
    A="                            ";
    echo -n "${A:0:-${#1}} $1: "
    if [[ -z "${!1}" ]]; then
        echo "❌"
        error=1
    else
        echo "✅"
    fi
}

# Check that the environment variables in the .env file have been defined.
check_env "FOREST_SLACK_API_TOKEN"
check_env "FOREST_SLACK_NOTIF_CHANNEL"
check_env "FOREST_TAG"
check_env "FOREST_TARGET_SCRIPTS"
check_env "FOREST_TARGET_DATA"
check_env "FOREST_TARGET_RUBY_COMMON"

if [ "$error" -ne "0" ]; then
    echo "Please set the required environment variables and try again."
  