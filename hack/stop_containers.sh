#!/bin/bash

# This script stops and removes all DNS test containers

set -e
set -o pipefail

CONTAINER_PREFIX="dns_test_container"

echo "Stopping and removing DNS test containers..."
CONTAINERS=$(docker ps -aq --filter "name=${CONTAINER_PREFIX}")

if [ -z "$CONTAINERS" ]; then
    echo "No containers found with prefix '${CONTAINER_PREFIX}'"
else
    docker rm -f $CONTAINERS
    echo "Successfully removed all DNS test containers!"
fi
