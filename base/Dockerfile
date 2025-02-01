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

# Initialize conda for both root and vscode user
RUN conda init bash && \
    su vscode -c "conda init bash" && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/vscode/.bashrc && \
    echo "conda activate research" >> /home/vscode/.bashrc

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH
ENV CONDA_AUTO_ACTIVATE_BASE=false
