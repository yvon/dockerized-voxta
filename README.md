# Docker Container for Voxta Server

This is a Docker container setup for running [Voxta](https://voxta.ai/), an AI voice chat application. 
Please note that Voxta is not my project - I'm just providing a Docker configuration for it.

## Prerequisites

Before building this container, you need to:

1. Download the Voxta Server Linux package zip file
2. Place this zip file in the same directory as the Dockerfile
   **Important**: The build will fail if this file is not present!

## Building and Running

### Basic version
1. Build the base Docker image:
   ```bash
   docker build --build-arg ZIP_FILE=your-voxta-server.zip -t voxta-server:latest .
   ```

2. Run the container:
   ```bash
   docker run -p 5384:5384 voxta-server:latest
   ```

### Preconfigured version (optional)
1. Place your override files in the `override/` directory.
   Any file placed here will overwrite the corresponding file in the base installation.
   
   Example: To use a preconfigured database, place it at:
   ```
   override/Data/Voxta.db
   ```

2. Build the preconfigured image (requires the base image to be built first):
   ```bash
   docker build -f Dockerfile.preconfigured --build-arg ZIP_FILE=your-voxta-server.zip -t voxta-server:preconfigured .
   ```

3. Run the preconfigured container:
   ```bash
   docker run -p 5384:5384 voxta-server:preconfigured
   ```

The server will be accessible at `http://localhost:5384`

## Deploying to Google Cloud Run

To deploy the container to Google Cloud Run, first set your project ID:

```bash
export GOOGLE_PROJECT=my-voxta-project-123
```

Then run these commands:

```bash
# Tag the preconfigured image for Google Container Registry (using v134 to match current Voxta version)
docker tag voxta-server:preconfigured gcr.io/${GOOGLE_PROJECT}/voxta-server:v134-preconfigured

# Push the image to Google Container Registry
docker push gcr.io/${GOOGLE_PROJECT}/voxta-server:v134-preconfigured

# Deploy to Cloud Run
gcloud run deploy voxta-server \
  --image gcr.io/${GOOGLE_PROJECT}/voxta-server:v134-preconfigured \
  --platform managed \
  --region europe-west1 \
  --port 5384 \
  --allow-unauthenticated
```

This will deploy the server and provide you with a public URL where your Voxta instance is accessible.
