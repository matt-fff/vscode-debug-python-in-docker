PROJECT_NAME=vscode-debug-python-in-docker

REGISTRY_IMAGE=typenil/$(PROJECT_NAME)

DOCKER_APPDIR=/var/app

ENABLE_DEBUGGING=false
DEBUGGER_PORT=4242
DEBUGGER_SECRET=tadpoles-turn-into-frogs

define msg
    @printf "\033[36m# %s\033[0m\n" $(1)
endef

build:
	$(call msg,"Building application Docker image")
	@docker build --pull -t $(REGISTRY_IMAGE) -f Dockerfile .

push:
	$(call msg,"Pushing application Docker image")
	@docker push $(REGISTRY_IMAGE)

pull:
	$(call msg,"Pulling application Docker image")
	@docker push $(REGISTRY_IMAGE)

run: rm
	$(call msg,"Starting application Docker container")
	@docker run -d \
		-p $(DEBUGGER_PORT):3000 \
		-e DEBUGGER_SECRET=$(DEBUGGER_SECRET) \
		-e DEBUG=$(ENABLE_DEBUGGING) \
		--volume $(PWD)/src:$(DOCKER_APPDIR)/src \
		--volume $(PWD)/tests:$(DOCKER_APPDIR)/tests \
		--name $(PROJECT_NAME) \
		$(REGISTRY_IMAGE)

logs:
	docker logs -f $(PROJECT_NAME)

stop:
	$(call msg,"Stopping application container")
	@docker stop $(PROJECT_NAME)

rm:
	$(call msg,"Removing application Docker container")
	-@docker rm -f $(PROJECT_NAME)

test: rm run
	$(call msg,"Running tests on test Docker container")
	@docker exec -it $(PROJECT_NAME) /bin/bash -c "py.test tests/"

format: rm run
	$(call msg,"Running Black Python formatter")
	@docker exec -it $(PROJECT_NAME) /bin/bash -c "time find . -iname '*.py' | xargs black"

lint: rm run
	$(call msg,"Running PyLint (minus TODOs) on test Docker container")
	@docker exec -it $(PROJECT_NAME) /bin/bash -c "time find . -iname '*.py' | xargs pylint --disable=fixme"

todos: rm run
	$(call msg,"Retrieving TODO lines on test Docker container")
	@docker exec -it $(PROJECT_NAME) /bin/bash -c "time find . -iname '*.py' | xargs pylint | grep '\[W0511(fixme)'"

code-coverage: rm run
	$(call msg,"Running code coverage on test Docker container")
	@docker exec -it $(PROJECT_NAME) /bin/bash -c "py.test --cov=$(DOCKER_APPDIR)/src $(DOCKER_APPDIR)/tests"

travis-coverage: rm run
	$(call msg,"Running coverage.py formatted for build")
	@docker exec -it $(PROJECT_NAME) /bin/bash -c "py.test --cov-report xml --cov=$(DOCKER_APPDIR)/src $(DOCKER_APPDIR)/tests/ > /dev/null 2>&1 && cat coverage.xml" | tee coverage.xml
