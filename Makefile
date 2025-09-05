TAG := latest
CONTAINER_REPO ?= ghcr.io/mqasimsarfraz/packetcounter
IMAGE_TAG ?= $(TAG)
CLANG_FORMAT ?= clang-format

.PHONY: build-gadget
build-gadget:
	sudo -E ig image build -t $(CONTAINER_REPO):$(IMAGE_TAG) .

.PHONY: build
build: build-gadget

.PHONY: push-gadget
push-gadget:
	sudo -E ig image push $(CONTAINER_REPO):$(IMAGE_TAG)

.PHONY: push
push: push-gadget

.PHONY: run
run: run-gadget

.PHONY: run-gadget
run-gadget:
	sudo -E ig run $(CONTAINER_REPO):$(IMAGE_TAG) $$PARAMS

.PHONY: clang-format
clang-format:
	find ./ -name '*.c' -o -name '*.h' | xargs $(CLANG_FORMAT)  -i