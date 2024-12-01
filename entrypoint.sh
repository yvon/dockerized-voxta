#!/bin/bash

# Check if Data directory is empty
if [ -z "$(ls -A /app/Data)" ]; then
    echo "Initializing Data directory with default content..."
    cp -r /app/Data_initial/* /app/Data/
fi

# Start Caddy in background
caddy reverse-proxy --from :80 --to :5384 &

# Start the server
./Voxta.Server
