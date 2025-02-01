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

# Setup user configuration
RUN groupmod -g 1001 vscode || groupadd -g 1001 vscode && \
    useradd -m -s /bin/bash -u 1001 vscode -g vscode || usermod -u 1001 -g vscode vscode && \
    chown -R vscode:vscode /home/vscode

# Ensure conda environment is properly set up
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV SHELL=/bin/bash

# Copy and setup Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Initialize conda for both root and vscode user
RUN conda init bash && \
    echo 'if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then . "/opt/conda/etc/profile.d/conda.sh"; fi' >> /etc/bash.bashrc && \
    echo 'conda activate research' >> /etc/bash.bashrc

USER vscode

# Initialize conda for vscode user
RUN conda init bash && \
    echo 'if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then . "/opt/conda/etc/profile.d/conda.sh"; fi' >> ~/.bashrc && \
    echo 'conda activate research' >> ~/.bashrc && \
    mkdir -p ~/.conda

USER root

# Set default shell to interactive bash
SHELL ["/bin/bash", "--login", "-c"]
CMD ["bash", "--login"]
