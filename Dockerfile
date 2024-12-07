FROM --platform=linux/amd64 ubuntu:latest
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Define ZIP file argument with default value
ARG ZIP_FILE=Voxta.Server.Linux.zip

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    unzip \
    debian-keyring \
    debian-archive-keyring \
    apt-transport-https \
    curl \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt-get update \
    && apt-get install -y caddy \
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

# Copy the entire application directory
COPY . .

# Unzip Voxta.Server.Linux.zip and setup Data directories
RUN unzip ${ZIP_FILE} \
    && mv Data Data_initial \
    && mkdir Data \
    && rm ${ZIP_FILE}

# Copy Prompts content to Resources/Prompts
COPY Prompts/. ./Resources/Prompts/

# Setup Python virtual environment
RUN python3.11 -m ensurepip --upgrade \
    && python3.11 -m venv Data_initial/Python/python-3.11-venv

# Copy entrypoint script
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

# Expose the Voxta Server port
EXPOSE 5384

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]
