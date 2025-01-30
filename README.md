# Development Environments

This repository contains development environment configurations using Dev Containers for various development purposes.

## Features

- Multiple pre-configured development environments:
  - Data Science environment for research and analysis
  - Web Development environment for full-stack development
  - Base environment with common development tools
- VS Code/Windsurf integration
- Code quality and development tools
- Remote development support

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
- Select the appropriate environment (data-science or web-dev)
- The container will be built automatically

## Available Environments

### Data Science Environment
Located in `.devcontainer/data-science/`:
- Python 3.12
- Conda environment management
- Essential data science packages (numpy, pandas, scipy)
- Visualization tools (matplotlib, seaborn, plotly)
- Code quality tools (flake8, black)
- Jupyter integration

### Web Development Environment
Located in `.devcontainer/web-dev/`:
- Node.js development environment
- Web development tools and extensions
- Code quality and formatting tools

### Base Environment
Located in `.devcontainer/base/`:
- Common development tools
- Basic VS Code extensions
- Git integration

## Directory Structure

- `.devcontainer/`: Contains all Dev Container configurations
  - `data-science/`: Data science environment configuration
  - `web-dev/`: Web development environment configuration
  - `base/`: Base development environment
  - `remote-setup.md`: Guide for remote development setup

## Remote Development

For remote development setup and requirements, please refer to `.devcontainer/remote-setup.md`.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

MIT License - See LICENSE file for details
