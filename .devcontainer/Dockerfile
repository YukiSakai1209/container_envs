ARG BASE_IMAGE=ghcr.io/yukisakai1209/research-env-base:latest
FROM ${BASE_IMAGE}

ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=1001

# Install basic dependencies and SSHFS
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    build-essential \
    sshfs \
    openssh-client \
    fuse3 \
    && rm -rf /var/lib/apt/lists/*

# Create the user and necessary directories
RUN usermod -u 1001 vscode \
    && groupmod -g 1001 vscode \
    && chown -R vscode:vscode /home/vscode \
    && mkdir -p /home/vscode/.ssh \
    && mkdir -p /home/vscode/vermeer \
    && chown -R vscode:vscode /home/vscode/.ssh \
    && chown -R vscode:vscode /home/vscode/vermeer

# Add FUSE device access
RUN echo "user_allow_other" >> /etc/fuse.conf

# Add build argument for environment file
ARG ENVIRONMENT_YML=environment.yml

# Copy environment.yml and create conda environment
COPY ${ENVIRONMENT_YML} /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml \
    && conda init bash \
    && echo "conda activate research" >> /home/vscode/.bashrc \
    && conda clean -a -y \
    && rm -rf /tmp/environment.yml

# Make sure the vscode user owns its home directory and the conda environment
RUN chown -R vscode:vscode /home/vscode /opt/conda/envs/research

USER $USERNAME
