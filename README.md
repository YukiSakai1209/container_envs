# Research Development Environment

This repository contains a development environment configuration using Dev Containers, specifically designed for neuroscience and psychiatric research.

## Features

- Unified research environment across different compute resources
- Full integration with VS Code
- Pre-configured scientific computing tools and libraries
- Remote development support with SSHFS integration
- PBS job submission support for compute clusters

## Using in a New Project

1. Create a new repository from this template:
   - Click "Use this template" on GitHub
   - Or manually copy the following files to your new project:
     ```
     .devcontainer/
     .gitignore
     README.md
     ```

2. Update `.devcontainer/devcontainer.json` to use a specific version:
   ```jsonc
   {
     "name": "Research Environment",
     "build": {
       "dockerfile": "Dockerfile",
       "args": {
         // Use a specific version of the base image
         "BASE_IMAGE": "ghcr.io/yukisakai1209/research-env-base:v2025.02.01"
       }
     }
   }
   ```
   - Replace `v2025.02.01` with your desired version
   - Or use `latest` for the most recent stable version

3. Set up the directory structure:
   ```
   your-project/
   ├── README.md              # Project overview
   ├── Instruction.md         # Private instructions (gitignored)
   ├── DATA/                  # Experimental data (if needed)
   ├── DEMO/                  # Demographic data (if needed)
   ├── ref/                   # Reference materials (if needed)
   ├── src/                   # Core components
   │   ├── components/
   │   ├── functions/
   │   └── main.py
   ├── analysis/             # Analysis scripts
   │   ├── analysis_01_<CONTENTS>.py
   │   └── analysis_02_<CONTENTS>.py
   ├── docs/                 # Private documentation (gitignored)
   ├── results/             # Analysis results
   └── archives/           # Archived code
   ```

4. Configure the environment:
   - Copy `.devcontainer/` to your project
   - The container will automatically:
     - Use the base image `ghcr.io/yukisakai1209/research-env-base`
     - Create and activate the `research` conda environment
     - Set up SSHFS mounts for remote access

5. Start development:
   ```bash
   # Clone your new repository
   git clone https://github.com/your-username/your-project.git
   cd your-project

   # Open in VS Code
   code .
   ```
   - Click "Reopen in Container" when prompted
   - The environment will be automatically set up

6. Add project-specific dependencies:
   - Create `base/environment.yml` for additional packages:
     ```yaml
     name: research
     channels:
       - conda-forge
     dependencies:
       # Add your project-specific packages here
       - python=3.12
       - numpy
       - pandas
     ```
   - Update `.devcontainer/Dockerfile`:
     ```dockerfile
     ARG BASE_IMAGE=ghcr.io/yukisakai1209/research-env-base:latest
     FROM ${BASE_IMAGE}

     # Copy and update environment if needed
     COPY base/environment.yml /tmp/
     RUN conda env update -n research -f /tmp/environment.yml
     ```

## Prerequisites

- Docker Desktop (for local development)
- VS Code with Dev Containers extension
- SSH access to compute servers (for remote development)

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/YukiSakai1209/container_envs.git
cd container_envs
```

2. Open in VS Code and click "Reopen in Container" when prompted
   - The container will be built automatically
   - The `research` conda environment will be activated automatically

## Environment Details

### Base Image
- Uses `ghcr.io/yukisakai1209/research-env-base` as the base image
- Python 3.12
- Scientific computing packages:
  - numpy, pandas, scipy
  - scikit-learn, optuna
  - matplotlib, seaborn
- Development tools:
  - black, ruff, pytest
  - Jupyter integration
- System tools:
  - git, sshfs, openssh-client, fuse3

### Remote Server Integration
- SSHFS mounts for seamless access to remote servers
- Automatic mounting of compute nodes

## Usage

### 1. Local Development
```bash
# Pull the latest base image
docker pull ghcr.io/yukisakai1209/research-env-base:latest

# Open in VS Code with Dev Containers
code .
```

### 2. Compute Server Usage
```bash
# On compute server
docker pull ghcr.io/yukisakai1209/research-env-base:latest
docker run -v $(pwd):/workspace ghcr.io/yukisakai1209/research-env-base:latest /opt/conda/envs/research/bin/python3 /workspace/your_script.py
```

### PBS Job Example
```bash
#!/bin/bash
#PBS -l nodes=1:ppn=4
#PBS -l walltime=24:00:00
#PBS -N your_job_name

cd $PBS_O_WORKDIR
docker run -v $(pwd):/workspace ghcr.io/yukisakai1209/research-env-base:latest /opt/conda/envs/research/bin/python3 /workspace/your_script.py
```

## Project Structure

```
.
├── README.md              # Project overview and setup instructions
├── Instruction.md         # Private instructions and project goals
├── DATA/                  # Experimental data (if exists)
├── DEMO/                  # Demographic data (if exists)
├── ref/                   # Reference materials (if exists)
├── src/                   # Core components and functions
│   ├── components/
│   ├── functions/
│   └── main.py
├── analysis/             # Analysis scripts
│   ├── analysis_01_<CONTENTS>.py
│   └── analysis_02_<CONTENTS>.py
├── docs/                 # Private documentation (not tracked in Git)
│   ├── analysis_01_<CONTENTS>.md
│   ├── analysis_02_<CONTENTS>.md
│   └── results_*.md
├── results/             # Analysis results
│   └── results_01_<CONTENTS>/
│   └── results_02_<CONTENTS>/
└── archives/           # Archived code
```

### Directory Naming Convention
- Use format: `<NUM>_<CONTENTS>`
- `<NUM>`: Experiment/result number
- `<CONTENTS>`: Brief description of analysis/experiment content
- Example: `analysis_01_preprocessing.py`

## Version Management

Container images use a date-based versioning system:
- `latest`: Most recent stable version
- Date-based tags: `vYYYY.MM.DD` (e.g., `v2025.02.01`)

To use a specific version:
```bash
docker pull ghcr.io/yukisakai1209/research-env-base:v2025.02.01
```

## Troubleshooting

1. Environment Issues
   - Ensure you're in the `research` conda environment
   - Check if all required packages are installed
   - Try rebuilding the container: "Dev Containers: Rebuild Container"

2. Remote Access Issues
   - Verify SSH keys are properly set up
   - Check SSHFS mounts: `mount | grep fuse`
   - Ensure required ports are accessible

## License

MIT License - See LICENSE file for details
