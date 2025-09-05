#!/bin/bash

# This script generates DNS requests from running DNS test containers

set -e
set -o pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <number_of_containers> <domain>"
    exit 1
fi

NUM_CONTAINERS=$1
DOMAIN=$2
CONTAINER_PREFIX="dns_test_container"

echo "Sending DNS requests to $DOMAIN..."

# Send DNS requests from each running container
for i in $(seq 1 $NUM_CONTAINERS); do
    CONTAINER_NAME="${CONTAINER_PREFIX}_$i"

    # Check if container exists and is running
    if ! docker ps --filter "name=$CONTAINER_NAME" --format "{{.Names}}" | grep -q "^$CONTAINER_NAME$"; then
        echo "Warning: Container $CONTAINER_NAME is not running, skipping..."
        continue
    fi

    if [ $i -eq 1 ]; then
        # Generate 5 requests from the first container
        echo "Sending 5 requests from container $CONTAINER_NAME..."
        for j in $(seq 1 5); do
            docker exec "$CONTAINER_NAME" nslookup -type=a "$DOMAIN"
            sleep 0.1
        done
    else
        # Single request from other containers
        echo "Sending 1 request from container $CONTAINER_NAME..."
        docker exec "$CONTAINER_NAME" nslookup -type=a "$DOMAIN"
        sleep 0.1
    fi
done

echo "DNS requests completed!"
