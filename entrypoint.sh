#!/bin/bash

# Check if Data directory is empty
if [ -z "$(ls -A /app/Data)" ]; then
    echo "Initializing Data directory with default content..."
    cp -r /app/Data_initial/* /app/Data/
fi

# Start Caddy in background
caddy start --config /app/Caddyfile

# Start the server
./Voxta.Server
