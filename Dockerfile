FROM --platform=linux/amd64 ubuntu:latest

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
COPY Voxta.Server.Linux.v1.0.0-beta.134.zip .
RUN unzip Voxta.Server.Linux.v1.0.0-beta.134.zip \
    && rm Voxta.Server.Linux.v1.0.0-beta.134.zip

# Update the server binding from localhost to 0.0.0.0 to allow external connections
RUN sed -i 's/"http:\/\/localhost:5384"/"http:\/\/0.0.0.0:5384"/g' appsettings.json

# Setup Python virtual environment
RUN python3.11 -m ensurepip --upgrade \
    && python3.11 -m venv Data/Python/python-3.11-venv


# Expose the Voxta Server port
EXPOSE 5384

# Command to run Voxta Server
CMD ["./Voxta.Server"]
