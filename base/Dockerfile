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

# Set environment variables
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV CONDA_AUTO_ACTIVATE_BASE=false

# Copy and setup Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Setup shell initialization
SHELL ["/bin/bash", "-c"]
RUN echo '. $CONDA_DIR/etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
    echo 'if [ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]; then . "$CONDA_DIR/etc/profile.d/conda.sh"; fi' >> /etc/profile && \
    echo 'conda activate research' >> /etc/profile

# Setup for vscode user
USER vscode
RUN echo 'if [ -f "$CONDA_DIR/etc/profile.d/conda.sh" ]; then . "$CONDA_DIR/etc/profile.d/conda.sh"; fi' >> ~/.bashrc && \
    echo 'conda activate research' >> ~/.bashrc && \
    mkdir -p ~/.conda && \
    conda init bash

USER root
