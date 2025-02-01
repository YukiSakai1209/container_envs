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

# Ensure conda environment is properly set up
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV CONDA_AUTO_ACTIVATE_BASE=false
ENV CONDA_DEFAULT_ENV=research

# Copy and setup Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Initialize conda for both root and vscode user
RUN conda init bash && \
    mkdir -p /etc/profile.d && \
    echo 'export CONDA_DIR=/opt/conda' > /etc/profile.d/conda-env.sh && \
    echo 'export PATH=$CONDA_DIR/bin:$PATH' >> /etc/profile.d/conda-env.sh && \
    echo '. "$CONDA_DIR/etc/profile.d/conda.sh"' >> /etc/profile.d/conda-env.sh && \
    echo 'conda activate research' >> /etc/profile.d/conda-env.sh && \
    chmod +x /etc/profile.d/conda-env.sh

# Setup for vscode user
USER vscode
RUN conda init bash && \
    echo 'source /etc/profile.d/conda-env.sh' >> ~/.bashrc

USER root

# Set default command
CMD ["/bin/bash", "--login"]
