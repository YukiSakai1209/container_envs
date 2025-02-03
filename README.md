# Research Development Environment

This repository contains a development environment configuration using Dev Containers, specifically designed for neuroscience and psychiatric research projects with VS code integration.

## Project Structure

Each research project follows this standardized structure, adhering to Python best practices:

```
research_project_root/              # Root directory for a specific research project
├── pyproject.toml                 # Project configuration and dependencies
├── README.md                      # Project overview and setup instructions
├── objectives.md                  # Research objectives and requirements
├── Makefile                       # Convenience commands for common tasks
│
├── src/                          # Source code for reusable components
│   ├── __init__.py
│   ├── config/                   # Configuration management
│   │   ├── __init__.py
│   │   └── settings.py          # Project-specific settings
│   ├── components/              # Reusable components
│   ├── functions/               # Core functions
│   └── visualization/           # Visualization utilities
│       ├── __init__.py
│       └── plots.py
│
├── analysis/                    # Analysis scripts (numbered sequentially)
│   ├── __init__.py
│   ├── analysis_01_<contents>.py
│   └── analysis_02_<contents>.py
│
├── data/                       # Data directory (if exists)
│   ├── raw/                   # Original, immutable data
│   ├── interim/              # Intermediate processed data
│   ├── processed/           # Final processed data
│   └── external/            # Data from external sources
│
├── demo/                    # Demographic data (if exists)
│
├── ref/                    # References and external resources (if exists)
│
├── models/                 # Trained models and predictions
│   ├── trained/           # Saved model states
│   └── predictions/       # Model outputs
│
├── docs/                  # Documentation
│   ├── analysis/         # Analysis documentation
│   │   ├── analysis_01_<contents>.md
│   │   └── analysis_02_<contents>.md
│   └── results/          # Results documentation
│       ├── results_01_<contents>.md
│       └── results_02_<contents>.md
│
├── results/              # Analysis results
│   ├── results_01_<contents>/
│   │   ├── figures/    # Generated figures
│   │   ├── tables/     # Generated tables
│   │   └── exports/    # Other exported results
│   └── results_02_<contents>/
│
├── notebooks/           # Jupyter notebooks (for exploration)
│   └── exploratory/    # Exploratory analysis notebooks
│
├── tests/              # Test suite
│   ├── __init__.py
│   ├── conftest.py    # Shared test fixtures
│   ├── test_env.py    # Environment tests
│   └── test_utils.py  # Utility function tests
│
└── archives/          # Archived code and results
```

### Multi-Project Setup

The repository supports multiple research projects, each following the same structure:

```
container_envs/
├── .devcontainer/           # Dev Container configuration
│   ├── Dockerfile
│   ├── devcontainer.json
│   └── docker-compose.yml
├── environments/           # Conda environment definitions
│   ├── base/
│   │   └── environment.yml
│   └── research/
│       └── environment.yml
├── project_a/             # Research project A
│   └── [project structure as above]
├── project_b/             # Research project B
│   └── [project structure as above]
└── shared/               # Shared resources across projects
    ├── src/             # Common source code
    ├── data/            # Shared datasets
    └── docs/            # Common documentation
```

### Naming Conventions

1. **Project Names**: Descriptive, lowercase with hyphens
   - Example: `cognitive-mapping-study`

2. **Analysis Files**: `analysis_XX_<contents>.py`
   - XX: Two-digit zero-padded number (01-99)
   - contents: Brief description in lowercase, words separated by hyphens
   - Example: `analysis_01_preprocessing.py`

3. **Results Directories**: `results_XX_<contents>/`
   - Matches corresponding analysis file number
   - Example: `results_01_preprocessing/`

4. **Documentation**: `<type>_XX_<contents>.md`
   - type: Either 'analysis' or 'results'
   - Example: `analysis_01_preprocessing.md`

5. **Python Files**:
   - Lowercase with underscores (snake_case)
   - Clear, descriptive names
   - Example: `data_processor.py`

## Development Setup

1. **Prerequisites**
   - Docker Desktop (Windows/Mac) or Docker Engine (Linux)
   - VS Code with Dev Containers extension
   - VS code extension installed

2. **Installation**
   ```bash
   git clone https://github.com/YukiSakai1209/container_envs.git
   cd container_envs
   code .  # Opens in VS Code
   ```

3. **Environment Setup**
   - Click "Reopen in Container" when prompted
   - The container will automatically:
     - Set up the conda environment
     - Configure git
     - Initialize SSHFS mounts if specified

## Project Configuration

### pyproject.toml

Each project includes a `pyproject.toml` for modern Python packaging:

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[project]
name = "research-project-name"
version = "0.1.0"
description = "Research project description"
requires-python = ">=3.8"
dependencies = [
    "numpy>=1.20",
    "pandas>=1.3",
    "matplotlib>=3.4",
    "seaborn>=0.11",
    "scipy>=1.7",
    "statsmodels>=0.13",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.0",
    "black>=22.0",
    "ruff>=0.1.0",
    "mypy>=1.0",
]
gpu = [
    "torch>=2.0",
    "tensorflow>=2.10",
]

[tool.black]
line-length = 88

[tool.ruff]
select = ["E", "F", "B"]
ignore = ["E501"]

[tool.mypy]
python_version = "3.8"
strict = true
```

## Development Workflow

1. **Starting a New Project**
   ```bash
   # Create new project directory
   mkdir project_name
   cd project_name
   # Initialize project structure
   make init-project
   ```

2. **Starting a New Analysis**
   ```bash
   # Create new analysis files
   make new-analysis NAME="feature_extraction"
   ```

3. **Running Analysis**
   ```bash
   # Run specific analysis
   python -m analysis.analysis_XX_<contents>
   ```

4. **Testing**
   ```bash
   # Run tests
   pytest
   # Run with coverage
   pytest --cov=src
   ```

5. **Code Quality**
   ```bash
   # Format code
   black .
   # Lint code
   ruff check .
   # Type checking
   mypy src tests
   ```

## Best Practices

1. **Code Organization**
   - Use `src` layout for better packaging
   - Keep analysis scripts separate from reusable code
   - Use relative imports within project

2. **Documentation**
   - Write docstrings in NumPy or Google style
   - Keep README.md up to date
   - Document analysis steps in markdown

3. **Testing**
   - Write tests for reusable components
   - Use pytest fixtures for common setup
   - Aim for high test coverage

4. **Version Control**
   - Use meaningful commit messages
   - Create feature branches for new analyses
   - Tag important milestones

5. **Data Management**
   - Never commit raw data
   - Document data preprocessing steps
   - Use data version control when appropriate

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
