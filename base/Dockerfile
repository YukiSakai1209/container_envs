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

# Create work directory and copy environment files
WORKDIR /tmp/conda-setup

# Accept environment.yml path as build argument
ARG ENVIRONMENT_YML=base/environment.yml
COPY ${ENVIRONMENT_YML} environment.yml

# Create conda environments and clean up
RUN conda update -n base conda && \
    conda install -n base conda-libmamba-solver && \
    conda config --set solver libmamba && \
    conda env create -f environment.yml -n research && \
    conda clean -afy && \
    rm -rf /tmp/conda-setup

# Set environment variables
ENV PATH=/opt/conda/bin:$PATH \
    SHELL=/bin/bash \
    CONDA_AUTO_ACTIVATE_BASE=false

# Initialize conda in system-wide profile
RUN echo '. /opt/conda/etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
    echo 'if [ -z "${CONDA_SHLVL+x}" ]; then' >> /etc/bash.bashrc && \
    echo '    conda activate research' >> /etc/bash.bashrc && \
    echo 'fi'  >> /etc/bash.bashrc

# Switch to vscode user and setup conda
USER vscode
WORKDIR /home/vscode

# Setup conda for vscode user
SHELL ["/bin/bash", "--login", "-c"]
RUN conda init bash && \
    echo 'if [ -z "${CONDA_SHLVL+x}" ]; then' >> ~/.bashrc && \
    echo '    conda activate research' >> ~/.bashrc && \
    echo 'fi'
