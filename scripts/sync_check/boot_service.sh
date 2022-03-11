#!/bin/bash

# The .env file contains environment variables that we want access to.
set -o allexport
# Trust that the `.env` exists in the CWD during the script execution.
# shellcheck disable=SC1091
source .env
set +o allexpo