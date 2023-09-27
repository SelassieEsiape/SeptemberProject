#!/bin/bash

# Docker image name
IMAGE_NAME="passwd-tst"

# Check if a list of ports was provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 PORT1 PORT2 PORT3 ..."
    exit 1
fi

# Loop through all provided ports and run the Docker container
for port in "$@"; do
    echo "Starting container on port $port..."
    docker run -d --rm -p $port:22 $IMAGE_NAME
done

echo "All containers started!"