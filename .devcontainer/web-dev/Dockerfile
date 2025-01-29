FROM mcr.microsoft.com/devcontainers/javascript-node:18

# Install additional packages
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install global npm packages
RUN npm install -g npm@latest typescript ts-node
