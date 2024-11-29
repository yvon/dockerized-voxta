# Docker Container for Voxta Server

This is a Docker container setup for running [Voxta](https://voxta.ai/), an AI voice chat application. 
Please note that Voxta is not my project - I'm just providing a Docker configuration for it.

## Prerequisites

Before building this container, you need to:

1. Download the Voxta Server Linux package zip file
2. Place this zip file in the same directory as the Dockerfile
   **Important**: The build will fail if this file is not present!

## Building and Running

1. Build the Docker image:
   ```bash
   docker build --build-arg ZIP_FILE=your-voxta-server.zip -t voxta-server .
   ```

2. Run the container:
   ```bash
   docker run -p 5384:5384 voxta-server
   ```

The server will be accessible at `http://localhost:5384`