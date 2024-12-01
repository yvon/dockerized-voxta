#!/bin/bash

# Function to handle graceful shutdown
cleanup() {
    echo "Shutting down..."
    kill $(jobs -p)
    exit
}

# Capture SIGTERM and SIGINT
trap cleanup SIGTERM SIGINT

# Check if Data directory is empty
if [ -z "$(ls -A /app/Data)" ]; then
    echo "Initializing Data directory with default content..."
    cp -r /app/Data_initial/* /app/Data/
fi

# Start Caddy in background
caddy reverse-proxy --from :80 --to :5384 &

# Start the server in background
./Voxta.Server &

# Wait for all background processes
wait
