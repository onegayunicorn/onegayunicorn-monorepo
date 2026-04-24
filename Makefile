# One Gay Unicorn Foundation Monorepo Makefile

.PHONY: help install build test lint format clean docs deploy

help: ## Show this help message
	@printf "One Gay Unicorn Foundation Monorepo\n"
	@printf "Available commands:\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

install: ## Install all dependencies
	pip install -r requirements.txt
	npm install

build: ## Build all packages
	echo "Building packages..."
