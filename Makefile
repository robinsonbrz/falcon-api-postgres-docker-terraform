default: 
	@echo "Comandos disponíveis"

	@echo "make start           - Inicializa container, e executa serviço"
	@echo "make stop            - Encerra execução dos containers BD"
	@echo "make test            - Fazer teste com o pytest"
	@echo "make lint            - Organiza o codigo"
	@echo "make black           - Black é um formatador de código Python que segue a PEP 8,"
	@echo "make isort           - Classifica automaticamente as importações em um arquivo de código Python"
	@echo "make flake8          - O Flake8 é um linter de código Python que verifica o estilo e a qualidade do código"
	@echo "make pre             - Pre analise do codigo antes do commit, Isort, Black Flake8 e um teste de coverage"

build:
	docker-compose -f docker-compose-dev.yml up -d --build

down:
	docker-compose -f docker-compose-dev.yml down

start:
	docker-compose -f docker-compose-dev.yml start	

stop:
	docker-compose -f docker-compose-dev.yml stop 

test:
	docker exec -ti web_falcon_dev  python -m pytest src --cov-report term --cov=src --cov-fail-under=30

lint:
	@echo "\n########## Runs isort, black and flake8. Organizing and linting code. ###########\n"
	@echo "############################### Running isort ###################################\n"
	docker exec -ti web_falcon_dev isort src
	docker exec -ti -u root web_falcon_dev chown -R app:app /home/app/src
	@echo "\n################################# Running black #################################\n"
	docker exec -ti web_falcon_dev black src
	docker exec -ti -u root web_falcon_dev chown -R app:app /home/app/src
	@echo "\n################################ Running flake8 ################################\n"
	docker exec -ti web_falcon_dev flake8 src
	docker exec -ti -u root web_falcon_dev chown -R app:app /home/app/src

pre: 
	make lint
	make test

isort:
	@echo "############################### Running isort ###################################\n"
	docker exec -ti web_falcon_dev isort src
	docker exec -ti -u root web_falcon_dev chown -R app:app /home/app/src

black:
	@echo "\n################################# Running black #################################\n"
	docker exec -ti web_falcon_dev black src
	docker exec -ti -u root web_falcon_dev chown -R app:app /home/app/src

flake8:
	@echo "\n################################ Running flake8. ################################\n"
	docker exec -ti web_falcon_dev flake8 src
	docker exec -ti -u root web_falcon_dev chown -R app:app /home/app/src

cov-html:
	@echo "\n################################ Running coverage-html. ################################\n"
	docker exec -ti web_falcon_dev	python -m pytest --cov-report html --cov src



