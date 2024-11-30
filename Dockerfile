FROM --platform=linux/amd64 ubuntu:latest

# Define ZIP file argument with default value
ARG ZIP_FILE=Voxta.Server.Linux.zip

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Add Python PPA and install Python 3.11
RUN add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update \
    && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3.11-venv \
    ffmpeg \
    libopenal-dev \
    && rm -rf /var/lib/apt/lists/*

# Create app directory
WORKDIR /app

# Copy and extract Voxta Server
COPY ${ZIP_FILE} .
RUN unzip ${ZIP_FILE} \
    && mv Data Data_initial \
    && mkdir Data
# Remove ZIP file after extraction
RUN rm ${ZIP_FILE}

# Update the server binding from localhost to 0.0.0.0 to allow external connections
RUN sed -i 's/"http:\/\/localhost:5384"/"http:\/\/0.0.0.0:5384"/g' appsettings.json

# Setup Python virtual environment
RUN python3.11 -m ensurepip --upgrade \
    && python3.11 -m venv Data_initial/Python/python-3.11-venv

# Copy entrypoint script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Expose the Voxta Server port
EXPOSE 5384

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
