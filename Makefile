PKG_ID := $(shell yq e ".id" manifest.yaml)
PKG_VERSION := $(shell yq e ".version" manifest.yaml)
TS_FILES := $(shell find ./ -name \*.ts)

# delete the target of a rule if it has changed and its recipe exits with a nonzero exit status
.DELETE_ON_ERROR:

all: verify

clean:
	rm -rf docker-images
	rm -f $(PKG_ID).s9pk
	rm -f image.tar
	rm -f scripts/*.js

verify: $(PKG_ID).s9pk
	@start-sdk verify s9pk $(PKG_ID).s9pk
	@echo " Done!"
	@echo "   Filesize: $(shell du -h $(PKG_ID).s9pk) is ready"

install: $(PKG_ID).s9pk
	start-cli package install $(PKG_ID).s9pk

$(PKG_ID).s9pk: manifest.yaml LICENSE docs/instructions.md icon.png scripts/embassy.js docker-images/aarch64.tar docker-images/x86_64.tar
	start-sdk pack

docker-images/aarch64.tar: Dockerfile docker_entrypoint.sh scripts/*.sh assets/*
	mkdir -p docker-images
	docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --platform=linux/arm64 --build-arg ARCH=aarch64 -o type=docker,dest=docker-images/aarch64.tar .

docker-images/x86_64.tar: Dockerfile docker_entrypoint.sh scripts/*.sh assets/*
	mkdir -p docker-images
	docker buildx build --tag start9/$(PKG_ID)/main:$(PKG_VERSION) --platform=linux/amd64 --build-arg ARCH=x86_64 -o type=docker,dest=docker-images/x86_64.tar .

scripts/embassy.js: $(TS_FILES)
	deno run --allow-read --allow-write --allow-env --allow-net scripts/bundle.ts
