FROM mcr.microsoft.com/devcontainers/miniconda:3

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy environment.yml
COPY environment.yml /tmp/environment.yml

# Create conda environment
RUN conda env create -f /tmp/environment.yml && \
    conda clean -a -y

# Initialize conda in bash and set default environment
RUN conda init bash && \
    echo "conda activate y_241209" >> /home/vscode/.bashrc

# Make sure the vscode user owns its home directory and the conda environment
RUN chown -R vscode:vscode /home/vscode /opt/conda/envs/y_241209
