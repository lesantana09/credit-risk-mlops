.DEFAULT_GOAL := help
.PHONY: help install lint format typecheck test check tf-fmt tf-validate

help: ## Lista os comandos disponíveis
	@grep -E '^[a-zA-Z_-]+:.*?## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-12s %s\n", $$1, $$2}'

install: ## Instala dependências e os hooks do pre-commit
	uv sync
	uv run pre-commit install

lint: ## Ruff (lint + checagem de formatação)
	uv run ruff check
	uv run ruff format --check

format: ## Formata e corrige o que for automático
	uv run ruff check --fix
	uv run ruff format

typecheck: ## mypy --strict
	uv run mypy

test: ## Testes com cobertura mínima de 80%
	uv run pytest

check: lint typecheck test ## Tudo que a CI roda

tf-fmt: ## Formata o Terraform
	terraform -chdir=infra/terraform fmt -recursive

tf-validate: ## Valida o módulo de bootstrap sem backend
	terraform -chdir=infra/terraform/bootstrap init -backend=false
	terraform -chdir=infra/terraform/bootstrap validate
