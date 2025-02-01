# Research Development Environment

This repository contains a development environment configuration using Dev Containers, specifically designed for neuroscience and psychiatric research.

## Features

- Unified research environment across different compute resources
- Full integration with VS Code
- Pre-configured scientific computing tools and libraries
- Remote development support with SSHFS integration
- PBS job submission support for compute clusters

## Prerequisites

- Docker Desktop (for local development)
- VS Code
- Dev Containers extension
- SSH access to compute servers (for remote development)

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/YukiSakai1209/container_envs.git
cd container_envs
```

2. Configure workspace:
- Open `.devcontainer/devcontainer.json`
- Modify `workspaceFolder` to point to your project directory
- Default: `/home/vscode/vermeer/container_envs`

3. Open in VS Code:
- Open the cloned directory
- When prompted, click "Reopen in Container"
- The container will be built automatically

## Environment Details

### Python Environment
- Python 3.12
- Scientific computing packages (numpy, pandas, scipy)
- Machine learning tools (scikit-learn, optuna)
- Visualization libraries (matplotlib, seaborn)
- Code quality tools (black, ruff)
- Jupyter integration

### Remote Server Integration
- SSHFS mounts for seamless access to remote servers
- Automatic mounting of:
  - vermeer (ncd-node01g)
  - magritte (ncd-node02g)
  - chagall (ncd-node03g)
  - picasso (ncd-node04g)
  - ncd (ncd-node05g)
  - xnef-data1 (ncd-node06g)
  - xnef-data2 (ncd-node07g)

## Usage Scenarios

### 1. Local Development
- Use VS Code with the Dev Container for development and testing
- All dependencies and tools are pre-configured
- Direct access to remote servers via SSHFS

### 2. Compute Server Usage
#### Option 1: Direct Container Usage
```bash
# On compute server
docker pull [your-container-registry]/research-env:latest
docker run -v /path/to/data:/data [your-container-registry]/research-env:latest python /data/your_script.py
```

#### Option 2: PBS Job Submission
1. Create a PBS script:
```bash
#!/bin/bash
#PBS -l nodes=1:ppn=4
#PBS -l walltime=24:00:00
#PBS -N your_job_name

cd $PBS_O_WORKDIR
docker run -v /path/to/data:/data [your-container-registry]/research-env:latest python /data/your_script.py
```

2. Submit the job:
```bash
qsub your_job_script.pbs
```

### 3. Shared Container Registry (Optional)
To optimize storage and ensure consistency across compute servers:
1. Set up a private container registry
2. Push your container image:
```bash
docker tag research-env:latest [registry-url]/research-env:latest
docker push [registry-url]/research-env:latest
```
3. Configure compute servers to pull from this registry

## Container Registry

We use GitHub Container Registry (GHCR) to distribute our development environment. This provides several benefits:

- Seamless integration with GitHub Actions for automated builds
- Built-in authentication using GitHub credentials
- Reliable and fast distribution of container images
- Version tracking with git commit hashes

### Using the Container Image

1. Authentication Setup
```bash
# Login to GHCR (required once per machine)
echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

2. Pull the Latest Image
```bash
# Pull the latest version
docker pull ghcr.io/yukisakai1209/research-env:latest

# Or pull a specific version using git commit hash
docker pull ghcr.io/yukisakai1209/research-env:<commit-hash>
```

### Environment Updates

The container image is automatically updated when changes are pushed to the main branch:

1. Changes to `.devcontainer/**` trigger automatic builds
2. New images are tagged with both `latest` and the git commit hash
3. To update your environment:
   - VS Code: Click "Rebuild Container"
   - Manual: Pull the latest image as shown above

### Usage on Compute Servers

1. First-time Setup
```bash
# On each compute server
echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

2. Regular Usage
```bash
# Pull the latest image
docker pull ghcr.io/yukisakai1209/research-env:latest

# Run with PBS
qsub -v IMAGE=ghcr.io/yukisakai1209/research-env:latest your_job_script.pbs
```

Example PBS script:
```bash
#!/bin/bash
#PBS -l nodes=1:ppn=4
#PBS -l walltime=24:00:00
#PBS -N your_job_name

cd $PBS_O_WORKDIR
docker run -v $(pwd):/workspace $IMAGE python /workspace/your_script.py
```

### Version Management

- `latest` tag: Always points to the most recent stable version
- Commit hash tags: Allows running specific versions for reproducibility
- To use a specific version:
  ```bash
  # In docker-compose.yml
  image: ghcr.io/yukisakai1209/research-env@sha256:<digest>
  ```

### Storage and Visibility

#### Storage Limits and Billing
- Public packages are free to use with no storage limits
- Currently, container image storage and bandwidth are in an extended free period
- When billing starts (with 1-month advance notice):
  - Free storage varies by account plan (e.g., 2GB for GitHub Team)
  - Overage charges:
    - Storage: $0.008 USD per GB per day
    - Data transfer: $0.50 USD per GB
  - Data transfer resets monthly, storage usage does not

#### Package Visibility
- Container images can be public even if your repositories are private
- Public packages in Container Registry:
  - Allow anonymous access
  - Can be pulled without authentication
  - Support direct CLI access
- Visibility can be managed independently of repository settings
- Perfect for sharing development environments while keeping code private

### Authentication

For private packages or publishing:
```bash
# Login to GHCR (required once per machine)
echo $GITHUB_PAT | docker login ghcr.io -u USERNAME --password-stdin
```

### Troubleshooting

1. Authentication Issues
   - Ensure you're logged in to GHCR
   - Check if your GitHub PAT has required permissions
   - Try re-authenticating: `docker login ghcr.io`

2. Pull Failures
   - Check network connectivity
   - Verify image name and tag
   - Ensure you have sufficient disk space

3. Container Startup Issues
   - Check if all required mounts are accessible
   - Verify SSH keys are properly set up for SSHFS
   - Review container logs: `docker logs <container-id>`

For additional help or to report issues, please use the GitHub Issues section of this repository.

## Directory Structure

```
.
├── .devcontainer/          # Dev Container configuration
├── DATA/                   # Data directory (if exists)
├── DEMO/                   # Demographic data (if exists)
├── ref/                    # Reference materials
├── analysis/              # Analysis scripts
│   ├── analysis_01_*.py
│   └── analysis_02_*.py
├── docs/                  # Documentation
│   ├── analysis_*.md
│   └── results_*.md
├── results/               # Results output
└── archives/             # Archived code
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## License

MIT License - See LICENSE file for details
