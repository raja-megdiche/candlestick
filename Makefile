# Makefile for Docker management

.PHONY: up down build restart logs

# Start docker containers
up:
	docker compose up -d

# Stop and remove containers
down:
	docker compose down --volumes

# Build containers
build:
	docker compose build

# Show logs
logs:
	docker compose logs -f
