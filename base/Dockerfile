# Base image for research environment
FROM mcr.microsoft.com/devcontainers/miniconda:0-3

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

# Copy and setup Conda environment
COPY environment.yml /tmp/environment.yml

# Initialize conda for shell
SHELL ["/bin/bash", "-c"]

# Create conda environment and clean up
RUN conda update -n base -c defaults conda && \
    conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH \
    CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    CONDA_AUTO_ACTIVATE_BASE=false

# Initialize conda in system-wide profile
RUN echo '. /opt/conda/etc/profile.d/conda.sh' > /etc/profile.d/conda.sh && \
    chmod +x /etc/profile.d/conda.sh && \
    echo '. /etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
    echo 'conda config --set auto_activate_base false' >> /etc/bash.bashrc && \
    echo 'conda activate research' >> /etc/bash.bashrc

# Switch to vscode user and setup conda
USER vscode
WORKDIR /home/vscode

# Setup conda for vscode user
RUN echo '. /opt/conda/etc/profile.d/conda.sh' >> ~/.bashrc && \
    echo 'conda config --set auto_activate_base false' >> ~/.bashrc && \
    echo 'conda activate research' >> ~/.bashrc && \
    echo 'export CONDA_AUTO_ACTIVATE_BASE=false' >> ~/.bashrc
