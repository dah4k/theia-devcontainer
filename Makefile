# Copyright 2024 dah4k
# SPDX-License-Identifier: EPL-2.0

DOCKER      ?= docker
REGISTRY    ?= local
IMAGES      ?= theia-devcontainer
TAGS        ?= $(addprefix $(REGISTRY)/,$(IMAGES))
_ANSI_NORM  := \033[0m
_ANSI_CYAN  := \033[36m

.PHONY: help usage
help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'

.PHONY: all
all: $(TAGS) ## Build all container images

$(REGISTRY)/%: Dockerfile.%
	$(DOCKER) build --tag $@ --file $< .

.PHONY: test
test: $(REGISTRY)/theia-devcontainer ## Test runtime container image
	$(DOCKER) run --detach --rm --publish 3000:3000 --name=theia-devcontainer $<
	@echo "Browse to http://localhost:3000"

.PHONY: debug
debug: $(REGISTRY)/theia-devcontainer ## Debug runtime container image
	$(DOCKER) run --interactive --tty --user root --rm --entrypoint=/bin/bash $<

.PHONY: clean
clean: ## Remove all container images
	$(DOCKER) stop theia-devcontainer || true
	$(DOCKER) image remove --force $(TAGS)

.PHONY: distclean
distclean: clean ## Prune all container images
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force
