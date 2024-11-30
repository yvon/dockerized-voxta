# Docker Container for Voxta Server

This is a Docker container setup for running [Voxta](https://voxta.ai/), an AI voice chat application. 
Please note that Voxta is not my project - I'm just providing a Docker configuration for it.

## Prerequisites

Before building this container, you need to:

1. Download the Voxta Server Linux package zip file
2. Place this zip file in the same directory as the Dockerfile
   **Important**: The build will fail if this file is not present!

## Building and Running

1. (Optional) Place any override files in the `override/` directory.
   Any file placed here will overwrite the corresponding file in the base installation.
   
   Example: To use preconfigured data files, place them in:
   ```
   override/Data/
   ```
   This will override any files in the base installation's Data directory.

2. Build the Docker image:
   ```bash
   docker build --build-arg ZIP_FILE=your-voxta-server.zip -t voxta-server:latest .
   ```

3. Run the container:
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

## Deploying to Google Cloud Run

To deploy the container to Google Cloud Run, first set your project ID:

```bash
export GOOGLE_PROJECT=my-voxta-project-123
```

Then run these commands:

```bash
# Tag the image for Google Container Registry
docker tag voxta-server:latest gcr.io/${GOOGLE_PROJECT}/voxta-server:latest

# Push the image to Google Container Registry
docker push gcr.io/${GOOGLE_PROJECT}/voxta-server:latest

# Deploy to Cloud Run
gcloud run deploy voxta-server \
  --image gcr.io/${GOOGLE_PROJECT}/voxta-server:latest \
  --platform managed \
  --region europe-west1 \
  --port 5384 \
  --allow-unauthenticated
```

This will deploy the server and provide you with a public URL where your Voxta instance is accessible.
