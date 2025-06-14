COLOR := $(shell git rev-parse HEAD | cut -c 1-6)
DOCKER_IMAGE ?= kwesi/rainbow-deploys

.PHONY: build
build: rainbow-deploys

rainbow-deploys: main.go
	go build

.PHONY: image
image:
	@echo Building with color $(COLOR)
	COLOR=$(COLOR) docker build . -t $(DOCKER_IMAGE):$(COLOR) --build-arg COLOR=$(COLOR)

.PHONY: push
push: image
	docker push $(DOCKER_IMAGE):$(COLOR)

.PHONY: install
install:
	cat app.yaml | sed s/__COLOR__/$(COLOR)/g | kubectl apply -f -
