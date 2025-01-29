FROM mcr.microsoft.com/devcontainers/miniconda:3

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy environment.yml
COPY environment.yml /tmp/environment.yml

# Create conda environment
RUN conda env create -f /tmp/environment.yml

# Initialize conda in bash
RUN conda init bash

# Set default environment
RUN echo "conda activate y_241209" >> ~/.bashrc

# Clean up
RUN conda clean -a -y
