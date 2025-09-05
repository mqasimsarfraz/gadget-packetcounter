#!/bin/bash

# This script starts DNS test containers and keeps them running

set -e
set -o pipefail

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number_of_containers>"
    exit 1
fi

NUM_CONTAINERS=$1
CONTAINER_PREFIX="dns_test_container"

# Start containers and keep them running
echo "Starting $NUM_CONTAINERS containers..."
for i in $(seq 1 $NUM_CONTAINERS); do
    docker run -d --name "${CONTAINER_PREFIX}_$i" busybox sleep 300
done

echo "Started $NUM_CONTAINERS containers successfully!"
