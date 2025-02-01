# Base image for research environment
FROM continuumio/miniconda3:latest

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

# Initialize conda in system-wide profile
RUN conda init bash && \
    echo '. "$CONDA_DIR/etc/profile.d/conda.sh"' >> /etc/bash.bashrc && \
    echo 'if [ -z "${CONDA_DEFAULT_ENV}" ]; then' >> /etc/bash.bashrc && \
    echo '    conda activate research' >> /etc/bash.bashrc && \
    echo 'fi'

# Setup for vscode user
USER vscode
WORKDIR /home/vscode

# Initialize conda for vscode user
RUN conda init bash && \
    echo '. "$CONDA_DIR/etc/profile.d/conda.sh"' >> ~/.bashrc && \
    echo 'if [ -z "${CONDA_DEFAULT_ENV}" ]; then' >> ~/.bashrc && \
    echo '    conda activate research' >> ~/.bashrc && \
    echo 'fi' && \
    mkdir -p ~/.conda

USER root

# Set default shell to interactive bash
SHELL ["/bin/bash", "--login", "-c"]
CMD ["bash", "--login"]
