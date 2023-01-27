# Use the default target when no target is specified
.DEFAULT_GOAL := help

# Variables
COMPOSE_FILE := docker-compose.yaml

help:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  up                 to start the containers"
	@echo "  down               to stop the containers"
	@echo "  build              to build the containers"
	@echo "  rebuild            to rebuild the containers"
	@echo "  logs               to view the logs"

up:
	docker-compose -f $(COMPOSE_FILE) up -d

down:
	docker-compose -f $(COMPOSE_FILE) down

build:
	docker-compose -f $(COMPOSE_FILE) build

rebuild:
	make down
	make build
	make up

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f
