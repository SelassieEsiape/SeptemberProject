#!/bin/bash

# Get all running container IDs
containers=$(docker ps -q)

# If there are any running containers, stop them
if [ ! -z "$containers" ]; then
    echo "Stopping running containers..."
    docker stop $containers
else
    echo "No containers are running."
fi
