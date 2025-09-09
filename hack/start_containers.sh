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
    if [ "$i" -eq 1 ]; then
        # use different sleep interval for the first container to avoid thundering herd
        docker run --rm -d --name "${CONTAINER_PREFIX}_$i" busybox sh -c 'while true; do nslookup -type=a example.com.; sleep 0.2; done'
        continue
    fi
    docker run --rm -d --name "${CONTAINER_PREFIX}_$i" busybox sh -c 'while true; do nslookup -type=a example.com.; sleep 0.5; done'
done

echo "Started $NUM_CONTAINERS containers successfully!"
