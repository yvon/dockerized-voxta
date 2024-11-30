# Docker Container for Voxta Server

This is a Docker container setup for running [Voxta](https://voxta.ai/), an AI voice chat application. 
Please note that Voxta is not my project - I'm just providing a Docker configuration for it.

## Prerequisites

Before deploying or building this container, you need to:

1. Download the Voxta Server Linux package zip file
2. Rename it to `Voxta.Server.Linux.zip` and place it in the same directory as the Dockerfile
   **Important**: The build will fail if this file is not present with exactly this name!

## Deploying to fly.io

1. Install the flyctl CLI if you haven't already by following the [official installation guide](https://fly.io/docs/flyctl/install/)

2. Login to fly.io:
   ```bash
   fly auth login
   ```

3. Launch your app (first time only):
   ```bash
   fly launch
   ```
   When asked "Would you like to copy its configuration to the new app?", answer "yes"

4. For subsequent deployments:
   ```bash
   fly deploy
   ```

Your app will be accessible at the URL provided by fly.io after deployment.

## Local Building and Running

1. Build the Docker image:
   ```bash
   docker build -t voxta-server:latest .
   ```

2. Run the container:
   ```bash
   docker run --name voxta-server -p 5384:5384 voxta-server:latest
   ```

The server will be accessible at `http://localhost:5384`

To manage the named container:
   ```bash
   docker stop voxta-server    # Stop the container
   docker start voxta-server   # Restart the container
   docker rm voxta-server      # Remove the container (must be stopped first)
   ```

