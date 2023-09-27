#!/bin/bash

# Build with Dockerfile
./build.sh

# Create 4 containers
./deploy.sh 2222 2223 2224 2225

# Some commands before the pause point
echo "Test is running!"

# Pause point
read -p "Press Enter to kill ALL Docker containers"

./cleanup.sh