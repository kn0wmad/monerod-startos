VERSION := $(shell yq e ".version" manifest.yaml)
VERSION_STRIPPED := $(shell echo $(VERSION) | sed -E 's/([0-9]+\.[0-9]+\.[0-9]+).*/\1/g')
ASSET_PATHS := $(shell find ./assets/*)
S9PK_PATH=$(shell find . -name monerod.s9pk -print)
TS_FILES := $(shell find . -name \*.ts )

.DELETE_ON_ERROR:

all: verify

clean:
		rm -f monerod.s9pk
		rm -f image.tar
		rm -f scripts/*.js

verify: monerod.s9pk $(S9PK_PATH)
		embassy-sdk verify s9pk $(S9PK_PATH)

monerod.s9pk: manifest.yaml image.tar docs/instructions.md icon.png $(ASSET_PATHS) scripts/embassy.js scripts/*.sh
		embassy-sdk pack

install: all
		embassy-cli package install monerod.s9pk

instructions.md: docs/instructions.md
	cp docs/instructions.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh manifest.yaml scripts/*.sh
		DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/monerod/main:$(VERSION) --build-arg MONERO_VERSION=$(VERSION_STRIPPED) --build-arg N_PROC=8 --platform=linux/arm64 -o type=docker,dest=image.tar .

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js
