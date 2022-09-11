VERSION := $(shell yq e ".version" manifest.yaml)
VERSION_STRIPPED := $(shell echo $(VERSION) | sed -E 's/([0-9]+\.[0-9]+\.[0-9]+).*/\1/g')
ASSET_PATHS := $(shell find ./assets/*)
S9PK_PATH=$(shell find . -name monerod.s9pk -print)
TS_FILES := $(shell find . -name \*.ts )
# MANAGER_SRC := $(shell find ./manager -name '*.rs') manager/Cargo.toml manager/Cargo.lock

.DELETE_ON_ERROR:

all: verify

clean:
		rm -f monerod.s9pk
		rm -f image.tar
		rm -f scripts/*.js

verify: monerod.s9pk $(S9PK_PATH)
		embassy-sdk verify s9pk $(S9PK_PATH)

monerod.s9pk: manifest.yaml image.tar docs/instructions.md icon.png $(ASSET_PATHS) scripts/embassy.js
		embassy-sdk pack
# 		embassy-sdk pack errors come from here, check your manifest, config, instructions, and icon

install: all
		embassy-cli package install monerod.s9pk

instructions.md: docs/instructions.md
	cp docs/instructions.md instructions.md

image.tar: Dockerfile docker_entrypoint.sh manager/target/aarch64-unknown-linux-musl/release/monerod-manager manifest.yaml
		DOCKER_CLI_EXPERIMENTAL=enabled docker buildx build --tag start9/monerod/main:$(VERSION) --build-arg MONERO_VERSION=$(VERSION_STRIPPED) --build-arg N_PROC=8 --platform=linux/arm64 -o type=docker,dest=image.tar .

scripts/embassy.js: $(TS_FILES)
	deno bundle scripts/embassy.ts scripts/embassy.js

manager/target/aarch64-unknown-linux-musl/release/monerod-manager: $(MANAGER_SRC)
		docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/manager:/home/rust/src start9/rust-musl-cross:aarch64-musl cargo build --release
		docker run --rm -it -v ~/.cargo/registry:/root/.cargo/registry -v "$(shell pwd)"/manager:/home/rust/src start9/rust-musl-cross:aarch64-musl musl-strip target/aarch64-unknown-linux-musl/release/monerod-manager