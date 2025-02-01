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

# Copy and setup Conda environment
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -afy

# Initialize conda in bash for both root and vscode user
RUN conda init bash && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> /etc/bash.bashrc && \
    echo 'conda activate research' >> /etc/bash.bashrc && \
    mkdir -p /etc/profile.d && \
    echo '. /opt/conda/etc/profile.d/conda.sh' > /etc/profile.d/conda.sh && \
    echo 'conda activate research' >> /etc/profile.d/conda.sh && \
    chmod +x /etc/profile.d/conda.sh

# Setup for vscode user
USER vscode
RUN conda init bash && \
    echo '. /opt/conda/etc/profile.d/conda.sh' >> ~/.bashrc && \
    echo 'conda activate research' >> ~/.bashrc && \
    mkdir -p ~/.conda

# Create a script to ensure conda is initialized
RUN echo '#!/bin/bash\n\
if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then\n\
    . "/opt/conda/etc/profile.d/conda.sh"\n\
fi\n\
conda activate research\n\
exec "$@"' > ~/.conda/ensure_conda.sh && \
    chmod +x ~/.conda/ensure_conda.sh

USER root

# Set default shell to interactive bash
SHELL ["/bin/bash", "--login", "-c"]
ENTRYPOINT ["/home/vscode/.conda/ensure_conda.sh"]
CMD ["bash", "--login"]
