# Base image for research environment
FROM mcr.microsoft.com/devcontainers/miniconda:3

# Install basic system dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    build-essential \
    sshfs \
    openssh-client \
    fuse3 \
    && rm -rf /var/lib/apt/lists/*

# Setup FUSE configuration for SSHFS
RUN echo "user_allow_other" >> /etc/fuse.conf

# Setup user configuration
RUN usermod -u 1001 vscode \
    && groupmod -g 1001 vscode \
    && chown -R vscode:vscode /home/vscode

# Copy and setup Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Set default shell to bash
SHELL ["/bin/bash", "-c"]

# Initialize conda and activate environment in bash
RUN conda init bash && \
    echo "conda activate research" >> /home/vscode/.bashrc
