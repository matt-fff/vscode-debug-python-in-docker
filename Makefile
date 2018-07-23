PROJECT_NAME=vscode-debug-python-in-docker
REGISTRY_IMAGE=typenil/$(PROJECT_NAME)
DOCKER_APPDIR=/var/app

ENABLE_DEBUGGING=true
EXTERNAL_DEBUG_PORT=4242
DEBUG_SECRET=tadpoles-turn-into-frogs

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
		-p $(EXTERNAL_DEBUG_PORT):3000 \
		-e DEBUG_SECRET=$(DEBUG_SECRET) \
		-e DEBUG_PORT=3000 \
		-e DEBUG=$(ENABLE_DEBUGGING) \
		--volume $(PWD)/src:$(DOCKER_APPDIR)/src \
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

