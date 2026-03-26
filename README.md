<!-- <div align="center">
  <img src="https://github.com/peinser/template/actions/workflows/docs.yml/badge.svg" alt="Docs">
  <img src="https://github.com/peinser/template/actions/workflows/image.yml/badge.svg" alt="Docker Image">
  <img src="https://github.com/peinser/template/actions/workflows/pypi.yml/badge.svg" alt="PyPI">
  <img src="https://badgen.net/badge/license/Apache-2.0/blue" alt="License">
  <img src="https://img.shields.io/pypi/v/template" alt="PyPI version">
  <img src="https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/ruff/main/assets/badge/v2.json" alt="Ruff">
  <img src="https://img.shields.io/docker/v/peinser/template" alt="Docker version">
</div>

<p align="center">
  <img src="docs/assets/logo.png" height=100%>
</p> -->

---

A modern Python package template with batteries included: strict type checking, automated linting, multi-stage Docker builds, MkDocs documentation, and a full CI/CD pipeline via GitHub Actions.

---

## Table of Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
  - [Option A — Dev Container (recommended)](#option-a--dev-container-recommended)
  - [Option B — Local Setup](#option-b--local-setup)
- [Project Structure](#project-structure)
- [Development Workflow](#development-workflow)
- [Running Tests](#running-tests)
- [Code Quality](#code-quality)
- [Documentation](#documentation)
- [Docker](#docker)
- [CI/CD](#cicd)
- [Publishing to PyPI](#publishing-to-pypi)
- [Customizing the Template](#customizing-the-template)
- [Contributing](#contributing)
- [License](#license)

---

## Features

| Area | Tooling |
|---|---|
| Package manager | [uv](https://github.com/astral-sh/uv) — fast, lock-file-based |
| Linting & formatting | [Ruff](https://github.com/astral-sh/ruff) |
| Type checking | [MyPy](https://mypy-lang.org/) (strict mode) |
| Testing | [pytest](https://pytest.org) + [pytest-asyncio](https://pytest-asyncio.readthedocs.io) + [pytest-cov](https://pytest-cov.readthedocs.io) |
| Security scanning | [Bandit](https://bandit.readthedocs.io) |
| Documentation | [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) with auto-generated API reference |
| Changelog | [towncrier](https://towncrier.readthedocs.io) |
| Build system | [Hatchling](https://hatch.pypa.io) |
| Containerization | Multi-stage Docker build (validate → production) |
| CI/CD | GitHub Actions (docs, Docker image, PyPI publish) |
| Dev environment | VS Code Dev Container with `act` for local workflow testing |

---

## Prerequisites

**For Option A (Dev Container):**
- [Docker](https://docs.docker.com/get-docker/) (Desktop or Engine)
- [VS Code](https://code.visualstudio.com/) with the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

**For Option B (local):**
- Python 3.12 or newer
- [uv](https://docs.astral.sh/uv/getting-started/installation/)

---

## Getting Started

### Option A — Dev Container (recommended)

The dev container provides a fully configured, reproducible environment with all tools pre-installed (including `act` for local CI testing).

1. **Clone the repository:**

   ```bash
   git clone https://github.com/peinser/template.git
   cd template
   ```

2. **Open in VS Code and reopen in container:**

   ```
   Ctrl+Shift+P  →  Dev Containers: Reopen in Container
   ```

   VS Code will build the container image and run the post-creation script, which installs all dependencies automatically via `uv sync --locked`.

3. **Verify the setup:**

   ```bash
   make help
   ```

That's it. Skip to [Development Workflow](#development-workflow).

---

### Option B — Local Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/peinser/template.git
   cd template
   ```

2. **Install uv** (if not already installed):

   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

3. **Install dependencies:**

   ```bash
   make setup
   ```

   This runs `uv sync --locked`, creating a virtual environment at `.venv/` and installing all pinned dependencies from `uv.lock`.

4. **Verify the setup:**

   ```bash
   make help
   ```

---

## Project Structure

```
template/
├── .changelog/          # Pending changelog entries (towncrier)
├── .dev/
│   └── compose.yml      # Docker Compose for the dev container service
├── .devcontainer/       # VS Code dev container definition
├── .github/
│   ├── dependabot.yml   # Automated dependency updates (weekly)
│   └── workflows/
│       ├── docs.yml     # Build and deploy documentation to GitHub Pages
│       ├── image.yml    # Build and push Docker image to registry
│       └── pypi.yml     # Build and publish package to PyPI
├── docker/
│   ├── Dockerfile       # Multi-stage build: builder → validate → production
│   └── entrypoint.sh    # Container entrypoint
├── docs/                # MkDocs source
├── examples/            # Usage examples (add yours here)
├── src/
│   └── template/        # Package source code
│       ├── __init__.py
│       └── __version__.py
├── tests/               # pytest test suite
├── CHANGELOG.md         # Auto-generated changelog
├── CONTRIBUTING.md      # Contribution guidelines
├── Makefile             # Common development tasks
├── mkdocs.yml           # Documentation configuration
├── pyproject.toml       # Project metadata, dependencies, and tool config
└── uv.lock              # Locked dependency versions (do not edit manually)
```

---

## Development Workflow

All common tasks are available through `make`. Run `make help` to see the full list.

| Command | Description |
|---|---|
| `make setup` | Install all dependencies (first-time setup) |
| `make sync` | Re-sync dependencies after editing `pyproject.toml` |
| `make lock` | Update `uv.lock` after adding or removing dependencies |
| `make format` | Auto-format code with Ruff |
| `make lint` | Run Ruff (linter) and MyPy (type checker) |
| `make test` | Run the test suite with coverage |
| `make clean` | Remove build artefacts and caches |
| `make all` | Full local CI pipeline: clean → install → lint → test |

### Adding a dependency

```bash
uv add <package>          # runtime dependency
uv add --dev <package>    # development-only dependency
make lock                 # update uv.lock
```

---

## Running Tests

```bash
make test
```

This runs `pytest` with branch coverage enabled. A minimum of **75%** coverage is required. To view a detailed HTML report:

```bash
uv run pytest --cov=src --cov-report=html
open htmlcov/index.html
```

Tests requiring async support use `pytest-asyncio`. Mark async test functions with `@pytest.mark.asyncio`.

---

## Code Quality

### Format

```bash
make format
```

Ruff reformats all source files in place (line length: 120).

### Lint

```bash
make lint
```

Runs two checks in sequence:

1. **Ruff** — covers flake8, isort, pyupgrade, bugbear, and more.
2. **MyPy** — strict type checking across `src/template/` and `tests/`.

Both checks must pass before a pull request can be merged.

### Security scan

Bandit runs automatically in the Docker `validate` stage and in the `image.yml` workflow. To run it locally:

```bash
uv run bandit -r src/
```

---

## Documentation

Documentation is written in Markdown and built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/). The API reference is generated automatically from docstrings.

### Serve locally

```bash
uv run --group docs mkdocs serve
```

Open [http://localhost:8000](http://localhost:8000) in your browser. The site rebuilds on file changes.

### Build

```bash
uv run --group docs mkdocs build
```

Output is written to `site/`.

### Deploy

Documentation is deployed to GitHub Pages automatically by the `docs.yml` workflow on every push to `main` that touches `docs/`, `src/`, or `mkdocs.yml`.

---

## Docker

The [Dockerfile](docker/Dockerfile) uses a three-stage build:

| Stage | Purpose |
|---|---|
| `builder-base` | Installs locked dependencies (no dev extras) |
| `validate` | Runs format check, Ruff, MyPy, pytest, and Bandit |
| `production` | Minimal runtime image; runs as a non-root user (UID 1001) |

### Build locally

```bash
# Run only the validation stage
docker build --target validate -f docker/Dockerfile .

# Build the final production image
docker build -f docker/Dockerfile -t template:local .
```

### Run

```bash
docker run --rm template:local
```

---

## CI/CD

Three GitHub Actions workflows handle the full pipeline:

| Workflow | Trigger | What it does |
|---|---|---|
| `docs.yml` | Push to `main` (docs/src/mkdocs) or manual | Builds and publishes documentation to GitHub Pages |
| `image.yml` | Push to `main`/`development` (docker/src/tests) or manual | Validates and builds the Docker image, pushes to registry |
| `pypi.yml` | Push to `main` or manual | Builds and publishes the package to PyPI |

[Dependabot](https://docs.github.com/en/code-security/dependabot) checks for outdated GitHub Actions and Python dependencies weekly, grouping updates into a single PR.

### Running workflows locally with `act`

The dev container ships with [`act`](https://github.com/nektos/act), which lets you run GitHub Actions workflows locally before pushing.

1. **Create a scoped Personal Access Token (PAT):**
   - GitHub → Settings → Developer settings → Personal access tokens → Fine-grained tokens
   - Restrict to **this repository only**
   - Required permissions: **Actions** (read & write), **Contents** (read & write)

2. **Export the token:**

   ```bash
   export GITHUB_TOKEN=ghp_your_token_here
   ```

3. **Run all workflows:**

   ```bash
   make act
   ```

4. **Run a specific job:**

   ```bash
   make act-job JOB=<job-name>
   ```

> **Security:** Store the PAT in a password manager. Never commit it to the repository. Revoke the token when it is no longer needed.

---

## Publishing to PyPI

The `pypi.yml` workflow publishes the package automatically on push to `main`. To enable it:

1. Generate an API token at [pypi.org/manage/account/token/](https://pypi.org/manage/account/token/).
2. Add it as a repository secret named `PYPI_API_KEY` under **Settings → Secrets and variables → Actions**.

To build the package locally without publishing:

```bash
uv build
```

Artefacts are written to `dist/`.

---

## Customizing the Template

After forking or using this template, rename the project to match your package:

1. **`pyproject.toml`** — update `name`, `version`, `description`, `authors`, and `requires-python`.
2. **`src/template/`** — rename the directory to your package name.
3. **`pyproject.toml`** — update `[tool.hatch.build.targets.wheel] packages` and all `[tool.mypy] files` / `[tool.towncrier] package` references.
4. **`mkdocs.yml`** — update `site_name` and any repository URLs.
5. **`.github/workflows/`** — update the Docker registry path and image name in `image.yml`.
6. **`README.md`** — replace badge URLs, logo, and project description.
7. **`CODEOWNERS`** — replace `@peinser` and `@JoeriHermans` with your GitHub handle(s).
8. **`docker/Dockerfile`** - replace `template`.

Other files containing references to `template`. Adjust accordingly.

```
./uv.lock
./CHANGELOG.md
./src/template/__init__.py
./src/template/__version__.py
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full contribution guide, including how to set up a PAT for local CI testing with `act`.

