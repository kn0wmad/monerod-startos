#!/bin/bash

# Install Docker
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker "$USER"
exec sudo su -l $USER

# Set Buildx as the default builder
docker buildx install
docker buildx create --use

# Enable cross-arch emulated builds in docker
docker run --privileged --rm linuxkit/binfmt:v0.8

# Setup qemu multi-arch builds
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes -c yes

# Install yq
sudo snap install yq

# Install deno
sudo snap install deno

# Install essentials build packages
sudo apt-get install -y build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates

# Install Rust
curl https://sh.rustup.rs -sSf | sh
# Choose nr 1 (default install)
source $HOME/.cargo/env

# Build and install embassy-sdk
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
cd embassy-os/backend/
./install-sdk.sh
embassy-sdk init

# Clone the Monero wrapper and built it
git clone https://github.com/Start9Labs/monerod-wrapper.git
cd monerod-wrapper
make