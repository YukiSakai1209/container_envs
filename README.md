# Research Development Environment

This repository contains a development environment configuration using Dev Containers, specifically designed for neuroscience and psychiatric research.

## Features

- Unified research environment across different compute resources
- Full integration with VS Code
- Pre-configured scientific computing tools and libraries
- Remote development support with SSHFS integration
- PBS job submission support for compute clusters

## Environment Selection

This repository provides two types of environment configurations:

1. **Base Environment** (`base/environment.yml`):
   - Lightweight development environment with minimal dependencies
   - Uses latest versions of packages for development flexibility
   - Includes development tools (black, ruff, pytest)
   - Suitable for:
     - Initial development and testing
     - Code formatting and linting
     - Quick prototyping

2. **Full Research Environment** (`.devcontainer/environment.yml`):
   - Complete research environment with version-locked dependencies
   - Includes extensive scientific and neuroscience packages
   - Ensures reproducibility across different systems
   - Suitable for:
     - Running actual analyses
     - Producing final results
     - Collaboration with version-controlled environment

### How to Choose

- For a new project, start with the **Base Environment** if you need flexibility during initial development
- Use the **Full Research Environment** when:
  - You need specific package versions for reproducibility
  - Your analysis requires specialized neuroscience packages
  - You're collaborating with others and need environment consistency
  - You're ready to run final analyses

Note: You should choose one environment type based on your project's needs. Mixing both environments is not recommended as it may lead to dependency conflicts.

### Switching Between Environments

To choose which environment to use when opening in Dev Container:

1. **Base Environment Setup**:
   ```jsonc
   // .devcontainer/devcontainer.json
   {
     "name": "Research Environment - Base",
     "build": {
       "dockerfile": "Dockerfile",
       "context": "..",
       "args": {
         "ENVIRONMENT_YML": "base/environment.yml"  // Point to base environment
       }
     }
   }
   ```

2. **Full Research Environment Setup**:
   ```jsonc
   // .devcontainer/devcontainer.json
   {
     "name": "Research Environment - Full",
     "build": {
       "dockerfile": "Dockerfile",
       "context": "..",
       "args": {
         "ENVIRONMENT_YML": ".devcontainer/environment.yml"  // Point to full environment
       }
     }
   }
   ```

3. **Switching Process**:
   1. Edit `.devcontainer/devcontainer.json` to point to your desired environment
   2. Run Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
   3. Select "Dev Containers: Rebuild Container"
   4. VS Code will rebuild with your selected environment

Note: Always commit your preferred environment configuration to ensure consistency across team members.

## Environment Setup

### Initial Setup

1. **Build the Base Environment**
   ```bash
   cd base
   docker build -t research-env .
   ```

2. **Configure VS Code**
   - Install the "Dev Containers" extension
   - Open the command palette (Ctrl+Shift+P or Cmd+Shift+P)
   - Select "Dev Containers: Open Folder in Container"
   - Choose your project directory

### Conda Environment Configuration

The container uses a robust conda initialization system that ensures the research environment is properly activated in all scenarios:

- **Automatic Initialization**: The container automatically initializes conda and activates the `research` environment through:
  - System-wide initialization in `/etc/bash.bashrc`
  - User-specific initialization in `~/.bashrc`
  - Login shell configuration
  - Custom entrypoint script

- **Environment Variables**:
  ```bash
  CONDA_DIR=/opt/conda
  PATH=$CONDA_DIR/bin:$PATH
  CONDA_AUTO_ACTIVATE_BASE=false
  ```

### Troubleshooting Conda Issues

If you encounter any conda-related issues:

1. **Verify Shell Type**
   ```bash
   # Should show '-bash' for login shell
   echo $0
   
   # If not in login shell, start one
   exec bash -l
   ```

2. **Check Conda Initialization**
   ```bash
   # Verify conda is properly sourced
   which conda
   
   # Should show /opt/conda/bin/conda
   echo $CONDA_DIR
   
   # Check if conda.sh exists
   ls -l /opt/conda/etc/profile.d/conda.sh
   ```

3. **Manual Environment Activation**
   ```bash
   # Source conda initialization
   . /opt/conda/etc/profile.d/conda.sh
   
   # Activate research environment
   conda activate research
   ```

4. **Reset Shell Environment**
   ```bash
   # Start a new login shell
   exec bash -l
   ```

If issues persist after trying these steps, you can:
1. Rebuild the container: `docker build -t research-env .`
2. Remove the container and recreate it in VS Code
3. Check the container logs for initialization errors

### Important Notes on Conda Environment

The container is configured to automatically initialize and activate the conda environment. The setup includes:

- Proper conda initialization for both root and vscode users
- Automatic activation of the `research` environment
- Environment variables set for consistent conda behavior
- Login shell configuration for proper environment loading

If you encounter any conda-related issues:

1. Ensure you're using a login shell:
   ```bash
   # Check if you're in a login shell
   echo $0
   # If not in a login shell, start one
   bash -l
   ```

2. Verify conda environment:
   ```bash
   # Check conda configuration
   conda info
   # Ensure research environment is active
   echo $CONDA_DEFAULT_ENV
   ```

3. If needed, manually source the conda configuration:
   ```bash
   source /etc/profile.d/conda-env.sh
   ```

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

## Sharing Dev Container Settings Across Projects

### Quick Setup for Existing Projects

1. **Copy Essential Files**
   ```bash
   # From container_envs repository
   cp -r .devcontainer /path/to/your/project/
   ```

2. **Adjust Workspace Path**
   - Edit `.devcontainer/devcontainer.json`:
   ```jsonc
   {
     "workspaceFolder": "/home/vscode/your/project/path",
     "workspaceMount": "source=${localWorkspaceFolder},target=/home/vscode/your/project/path,type=bind"
   }
   ```

3. **Mount Parent Directory**
   - Edit `.devcontainer/docker-compose.yml`:
   ```yaml
   services:
     workspace:
       volumes:
         - type: bind
           source: /path/to/parent/dir
           target: /home/vscode/parent/dir
   ```

### Best Practices for Sharing

1. **Use Relative Paths When Possible**
   - Use `${localWorkspaceFolder}` in `devcontainer.json`
   - Reference paths relative to the workspace root

2. **Share Common Settings**
   - Keep shared settings in `container_envs`
   - Only override project-specific settings in individual projects

3. **Version Control**
   - Track `.devcontainer/` in Git
   - Use `.gitignore` for project-specific secrets

4. **Environment Management**
   - Base environment: Use the standard `research` conda env
   - Project-specific: Add `base/environment.yml` for extra packages

### Troubleshooting Common Issues

1. **Permission Issues**
   - Ensure correct UID/GID in `docker-compose.yml`:
   ```yaml
   args:
     USER_UID: "1001"  # Match your host user ID
     USER_GID: "1001"  # Match your host group ID
   ```

2. **Mount Problems**
   - Check if source paths exist on host
   - Verify target paths in container
   - Ensure FUSE support is enabled

3. **Environment Conflicts**
   - Use conda environments to isolate dependencies
   - Keep `base/environment.yml` up to date

### Example: Multi-Project Setup

```
/home/user/
└── vermeer/                 # Parent directory
    ├── container_envs/      # Base configuration
    │   └── .devcontainer/
    └── project_a/          # Your project
        ├── .devcontainer/  # Project-specific settings
        │   ├── devcontainer.json
        │   └── docker-compose.yml
        └── base/
            └── environment.yml
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

### Critical Path Configuration

> ⚠️ **Most Common Failure Point**: Path configuration mismatches between host and container

To avoid path-related issues, follow these exact steps:

1. **Identify Your Project Structure**
   ```bash
   # Example structure
   /home/username/vermeer/              # Parent directory
   ├── container_envs/                  # This repository
   └── your_project/                    # Your project directory
   ```

2. **Configure Container Paths**
   - In `.devcontainer/devcontainer.json`:
   ```jsonc
   {
     "name": "Research Environment",
     "dockerComposeFile": "docker-compose.yml",
     "service": "workspace",
     // IMPORTANT: This must match your project path inside the container
     "workspaceFolder": "/home/vscode/vermeer/your_project",
     // CRITICAL: This maps your local project to the container
     "workspaceMount": "source=${localWorkspaceFolder},target=/home/vscode/vermeer/your_project,type=bind",
     // Other settings...
   }
   ```

3. **Set Up Parent Directory Mount**
   - In `.devcontainer/docker-compose.yml`:
   ```yaml
   services:
     workspace:
       # ... other settings ...
       volumes:
         - type: bind
           source: ${HOME}/.ssh  # SSH keys
           target: /home/vscode/.ssh
         - type: bind
           source: /home/username/vermeer  # CRITICAL: Parent directory
           target: /home/vscode/vermeer    # Must match workspaceFolder path
   ```

### Validation Checklist

Before starting the container, verify:

1. **Path Consistency**
   ```bash
   # Check your actual paths
   echo $HOME                    # Should match source paths
   ls -la /home/username/vermeer # Verify parent directory exists
   ```

2. **Permission Setup**
   ```bash
   # Check your user ID and group ID
   id -u  # Usually 1000 or 1001
   id -g  # Usually 1000 or 1001
   
   # Update docker-compose.yml if needed
   args:
     USER_UID: "1001"  # Must match your id -u
     USER_GID: "1001"  # Must match your id -g
   ```

3. **Mount Points**
   ```bash
   # Verify mount source directories exist
   test -d ${HOME}/.ssh && echo "SSH directory exists" || echo "Missing SSH directory"
   test -d /home/username/vermeer && echo "Parent directory exists" || echo "Missing parent directory"
   ```

### Troubleshooting Guide

If you encounter issues:

1. **Container Won't Start**
   ```bash
   # Check Docker logs
   docker logs $(docker ps -qf "name=your_project")
   
   # Verify FUSE support
   docker run --rm --privileged alpine ls /dev/fuse
   ```

2. **Path Resolution Problems**
   ```bash
   # Inside container
   pwd                 # Should show /home/vscode/vermeer/your_project
   ls -la /home/vscode # Check mount points
   ```

3. **Permission Denied**
   ```bash
   # Inside container
   id                  # Verify UID/GID
   ls -la /home/vscode # Check directory permissions
   ```

### Recovery Steps

If you need to reset your setup:

1. **Clean Up**
   ```bash
   # Remove existing container
   docker-compose -f .devcontainer/docker-compose.yml down
   
   # Clean Docker cache
   docker builder prune -f
   ```

2. **Reset Configuration**
   ```bash
   # Backup current config
   cp -r .devcontainer .devcontainer.bak
   
   # Copy fresh config from container_envs
   cp -r ../container_envs/.devcontainer .
   ```

3. **Verify and Restart**
   ```bash
   # Update paths
   sed -i "s|/path/to/replace|$HOME/vermeer/your_project|g" .devcontainer/devcontainer.json
   
   # Restart VS Code
   code .
   ```

## Research Environment Setup

This repository contains the configuration for a research-focused development environment using Docker containers and VSCode Dev Containers.

## Environment Configuration

The environment is built on top of `continuumio/miniconda3` and includes:
- Python with conda package management
- Essential system utilities (git, build-essential, etc.)
- SSHFS support for remote filesystem mounting

### Conda Environment Setup

The environment uses a dedicated conda environment named `research` defined in `environment.yml`. The conda initialization is handled automatically through several mechanisms:

1. System-wide initialization in `/etc/bash.bashrc`
2. User-specific initialization in `~/.bashrc`
3. VSCode integrated terminal configuration

#### Important Settings

The following VSCode settings are crucial for proper conda environment activation:

```json
{
    "terminal.integrated.inheritEnv": false,
    "python.terminal.activateEnvironment": true,
    "terminal.integrated.defaultProfile.linux": "bash"
}
```

These settings are automatically configured in the Dev Container.

## Troubleshooting

### Conda Activation Issues

If you encounter the error `CondaError: Run 'conda init' before 'conda activate'`, try the following steps:

1. Ensure you're using the latest version of the container:
   ```bash
   cd ~/vermeer/container_envs/base
   docker build -t research-env .
   ```

2. Restart VSCode completely and reopen the Dev Container

3. Verify the conda initialization:
   ```bash
   echo $CONDA_DIR
   ls -l $CONDA_DIR/etc/profile.d/conda.sh
   conda info
   ```

4. If issues persist, check that:
   - The integrated terminal is using bash as the default shell
   - The terminal is started as a login shell
   - The conda initialization files exist and are properly sourced

### Environment Reset

If you need to completely reset the environment:

1. Stop and remove existing containers:
   ```bash
   docker ps -a | grep research-env | awk '{print $1}' | xargs -r docker stop
   docker ps -a | grep research-env | awk '{print $1}' | xargs -r docker rm
   ```

2. Remove the image:
   ```bash
   docker image rm research-env
   ```

3. Backup and clear local conda files:
   ```bash
   mkdir -p ~/conda_backup
   mv ~/.condarc ~/conda_backup/ 2>/dev/null || true
   mv ~/.conda ~/conda_backup/ 2>/dev/null || true
   ```

4. Rebuild the environment:
   ```bash
   cd ~/vermeer/container_envs/base
   docker build -t research-env .
   ```

5. Restart VSCode and reopen the Dev Container
