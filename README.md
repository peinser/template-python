---

A modern Python package template with batteries included: strict type checking, automated linting, multi-stage Docker builds, MkDocs documentation, and a full CI/CD pipeline via GitHub Actions.

Powered by [Copier](https://copier.readthedocs.io) — scaffold a new project in seconds, and keep it up to date as the template evolves.

---

## Table of Contents

- [Features](#features)
- [Using this Template](#using-this-template)
  - [Generating a New Project](#generating-a-new-project)
  - [Updating an Existing Project](#updating-an-existing-project)
  - [Template Variables](#template-variables)
- [Working on the Template Itself](#working-on-the-template-itself)
  - [Prerequisites](#prerequisites)
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
- [Contributing](#contributing)
- [License](#license)

---

## Using this Template

### Generating a New Project

> **Requirement:** Copier 9.0 or newer. Install it once with:
> ```bash
> pipx install copier
> # or
> uv tool install copier
> ```

Run the following command and answer the prompts:

```bash
copier copy gh:peinser/template <destination-directory>
```

Copier will ask for:

| Variable | Description |
|---|---|
| `project_name` | Human-readable name (e.g. `My Awesome Library`) |
| `project_description` | One-line description of the project |
| `author_name` | Your full name |
| `author_email` | Your e-mail address |
| `repo_url` | Full HTTPS GitHub URL (e.g. `https://github.com/owner/repo`) |
| `module_name` | Python module name — lowercase, underscores only (e.g. `my_library`) |

After generation, `git init` and `git add .` are run automatically. Then:

```bash
cd <destination-directory>
uv sync --locked    # install all dependencies
make help           # see available tasks
```

> **Tip:** The answers are stored in `.copier-answers.yml` inside the generated project. Do not delete this file — it is required for future updates.

### Updating an Existing Project

When this template is updated, regenerate your project to pull in the latest changes:

```bash
cd <your-project>
copier update
```

Copier replays your original answers, applies the diff, and lets you resolve any conflicts. Review the changes with `git diff` before committing.

### Template Variables

All variables are validated at prompt time:

- `author_email` must match a basic `user@host.tld` pattern.
- `repo_url` must start with `https://github.com/`.
- `module_name` must be a valid Python identifier: starts with a lowercase letter, followed by lowercase letters, digits, or underscores.

---

## Working on the Template Itself

The sections below describe the reference project bundled with this template. They also serve as living documentation for the generated project's `README.md`.

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

This project uses [`uv`](https://docs.astral.sh/uv/) for building and publishing. Releases are published automatically via GitHub Actions using **Trusted Publishing** (OIDC), which is the most secure method in 2026 — no long-lived API tokens are required.

### 1. Create a GitHub Environment (Recommended)

1. Go to your repository → **Settings** → **Environments** → **New environment**.
2. Name it **`pypi`** (this name is conventional and works well with the workflow).
3. (Optional but recommended) Add **protection rules**:
   - Require manual approval from specific people/teams (adds a safety gate before publishing).
   - You can also restrict which branches or tags can deploy to this environment.

This environment provides an extra layer of control and clearly signals that the job is performing a production release.

### 2. Configure Trusted Publishing on PyPI

You only need to do this **once** per package (or when you change the workflow name/repository).

1. Go to [https://pypi.org/manage/account/publishing/](https://pypi.org/manage/account/publishing/) (or navigate to your project → **Manage** → **Publishing**).
2. Click **Add a new trusted publisher**.
3. Fill in the following details:
   - **Publisher**: `GitHub`
   - **Repository owner**: your GitHub username or organization (e.g. `peinser`)
   - **Repository name**: the name of this repo (e.g. `template`)
   - **Workflow filename**: `pypi.yml` (or whatever you name the workflow file, e.g. `.github/workflows/pypi.yml`)
   - **Environment name**: `pypi` (must match the environment you created in GitHub)

4. Save the trusted publisher.

> **Tip**: You can add the same trusted publisher for TestPyPI if you want to test releases first.

### 3. Workflow Setup

The publishing workflow (`.github/workflows/pypi.yml`) should look similar to this (see the full recommended version in the repository):

- It uses `astral-sh/setup-uv@v7`
- It builds with `uv build --frozen`
- It publishes with `uv publish` using **Trusted Publishing** (no `PYPI_API_KEY` secret needed)
- The job references the `pypi` environment and has the required `id-token: write` permission

### 4. How to Release a New Version

1. Update the version in `pyproject.toml`.
2. Commit and push to `main`.
3. (Recommended) Create a **GitHub Release** with a tag like `v1.2.3` — this is the cleanest trigger.
   - Or manually trigger the **PyPI** workflow from the **Actions** tab.

The workflow will:
- Build the source distribution and wheel
- Perform a quick smoke test
- Publish to PyPI (after manual approval if you enabled it)

### Security Notes

- **Trusted Publishing** eliminates the need to store PyPI tokens as GitHub secrets.
- Using a dedicated `pypi` environment + manual approval.
- The workflow only runs on protected branches/tags (adjust the `on:` trigger as needed).

---

## Customizing the Template

All renaming and substitution is handled automatically by Copier — see [Using this Template](#using-this-template).

After generation you may still want to manually adjust:

- **`.github/workflows/image.yml`** — update the Docker registry path and image name.
- **`CODEOWNERS`** — replace the placeholder GitHub handle(s) with your own.
- **`docker/entrypoint.sh`** — add your application's startup logic.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full contribution guide, including how to set up a PAT for local CI testing with `act`.

