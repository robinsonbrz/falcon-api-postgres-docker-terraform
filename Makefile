# Variables
DOCKER_COMPOSE_FILE = docker-compose -f docker-compose-dev.yml
DOCKER_CONTAINER = web_falcon_dev

# Targets
.PHONY: build down start stop test cov-html lint pre isort black flake8

# Docker container management
build:
	$(DOCKER_COMPOSE_FILE) up -d --build

down:
	$(DOCKER_COMPOSE_FILE) down

start:
	$(DOCKER_COMPOSE_FILE) start

stop:
	$(DOCKER_COMPOSE_FILE) stop

# Testing
test:
	@echo "\n####################### Running tests with coverage ###########################\n"
	docker exec -ti $(DOCKER_CONTAINER) python -m pytest ./ --cov-report term --cov=./ --cov-fail-under=30

cov-html:
	@echo "\n################################ Running coverage-html ################################\n"
	docker exec -ti $(DOCKER_CONTAINER) python -m pytest --cov-report html --cov src

# Linting and code formatting
lint:
	@echo "\n########## Running isort, black, and flake8. Organizing and linting code ###########\n"
	$(MAKE) isort
	$(MAKE) black
	$(MAKE) flake8

pre: 
	$(MAKE) lint
	$(MAKE) test

# Individual formatters and linters
isort:
	@echo "\n############################### Running isort ###################################\n"
	docker exec -ti $(DOCKER_CONTAINER) isort .
	docker exec -ti -u root $(DOCKER_CONTAINER) chown -R app:app /home

black:
	@echo "\n################################# Running black #################################\n"
	docker exec -ti $(DOCKER_CONTAINER) black .
	docker exec -ti -u root $(DOCKER_CONTAINER) chown -R app:app /home

flake8:
	@echo "\n################################ Running flake8 ################################\n"
	docker exec -ti $(DOCKER_CONTAINER) flake8 .
	docker exec -ti -u root $(DOCKER_CONTAINER) chown -R app:app /home
