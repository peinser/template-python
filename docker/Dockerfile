# python-base #################################################################

FROM python:3.12-slim AS python-base

LABEL artifact=false

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

# builder-base ################################################################

FROM python-base AS builder-base

LABEL artifact=false

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    curl

ENV POETRY_VERSION=1.6.1
RUN curl -sSL https://install.python-poetry.org | python -

WORKDIR ${PYSETUP_PATH}
COPY . .
RUN poetry install --only=main && poetry build

# validate ####################################################################

FROM builder-base AS validate

LABEL artifact=false

COPY . .
RUN poetry install --with=dev --with=main && \
    # Linting
    poetry run black --check --diff src/template && \
    poetry run ruff check src/template && \
    poetry run mypy src/template && \
    # Tests and coverage
    # Disable coverage for now.
    poetry run coverage run -m pytest --cov=src/template \
    # Security
    poetry run bandit src && \
    poetry run safety check

# production ##################################################################

FROM python-base AS production

LABEL artifact=true

WORKDIR /app

COPY --from=builder-base $VENV_PATH $VENV_PATH
COPY --from=builder-base ${PYSETUP_PATH}/dist/template*.whl .
COPY ./docker/entrypoint.sh ./entrypoint.sh

RUN pip install template*.whl && rm template*.whl && \
    chmod +x ./entrypoint.sh

ENTRYPOINT ./entrypoint.sh $0 $@
