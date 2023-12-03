.PHONY: docs test examples

docs:
	poetry run mkdocs serve

lint:
	poetry run black --diff src/template
	poetry run ruff check src/template --fix
	poetry run mypy src/template

examples:
	poetry run black --diff examples
	poetry run ruff check examples --fix
	poetry run mypy examples

test:
	poetry run coverage run -m pytest --cov=src/template
