# Neuroscience Development Environment

This repository contains a development environment setup for neuroscience research using Dev Containers.

## Features

- Pre-configured development environment for neuroscience research
- Data science tools and libraries
- GPU support for computational tasks
- Jupyter Lab integration
- Code quality tools

## Prerequisites

- Docker Desktop
- VS Code or Windsurf
- Dev Containers extension

## Quick Start

1. Clone this repository:
```bash
git clone https://github.com/YukiSakai1209/container_envs.git
cd container_envs
```

2. Open in VS Code/Windsurf:
- Open the cloned directory
- When prompted, click "Reopen in Container"
- The container will be built automatically

Alternatively, you can pull the pre-built Docker image:
```bash
docker pull yukisakai1209/neuro-science-dev:latest
```

## Environment Details

The development environment includes:

- Python 3.10+
- Essential data science packages (numpy, pandas, scipy)
- Machine learning frameworks (scikit-learn, pytorch)
- Visualization tools (matplotlib, seaborn, plotly)
- Performance optimization tools (numba, cython)
- Code quality tools (flake8, black)

## Updating the Environment

The environment is automatically updated when changes are pushed to the main branch. To get the latest version:

1. Pull the latest changes from GitHub:
```bash
git pull origin main
```

2. Rebuild the Dev Container:
- VS Code: Click the "Rebuild Container" button in the command palette
- Windsurf: Use the Dev Container rebuild option
- Docker: Pull the latest image:
```bash
docker pull yukisakai1209/neuro-science-dev:latest
```

## Directory Structure

- `.devcontainer/`: Contains all Dev Container configurations
  - `data-science/`: Data science environment configuration
  - `base/`: Base development environment
  - `ml/`: Machine learning specific configuration

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

MIT License - See LICENSE file for details
