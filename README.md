# StartOS Wrapper for Monero

This project wraps the Monero daemon for StartOS. Monero is a private, secure, untraceable, decentralised digital currency. You are your bank, you control your funds, and nobody can trace your transfers unless you allow them to do so. Learn more at https://www.getmonero.org/

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [start-sdk](https://github.com/Start9Labs/start-os/tree/master/backend)

## Build enviroment

Prepare your StartOS build enviroment. In this example we are using Debian.

1. Install docker

```
curl -fsSL https://get.docker.com -o- | bash
sudo usermod -aG docker "$USER"
exec sudo su -l $USER
```

2. Set buildx as the default builder

```
docker buildx install
docker buildx create --use
```

3. Enable cross-arch emulated builds in docker

```
docker run --privileged --rm linuxkit/binfmt:v0.8
```

4. Install yq

Ubuntu:

```
sudo snap install yq
```

Debian:

```
PLATFORM=$(dpkg --print-architecture)
wget -q https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${PLATFORM} && sudo mv yq_linux_${PLATFORM} /usr/local/bin/yq && sudo chmod +x /usr/local/bin/yq
```

5. Install deno

```
cargo install deno
```

6. Install essentials build packages

```
sudo apt-get install -y build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates
```

7. Install Rust

```
curl https://sh.rustup.rs -sSf | sh
# Choose nr 1 (default install)
source $HOME/.cargo/env
```

8. Build and install start-sdk

```
cd ~/ && git clone --recursive https://github.com/Start9Labs/start-os.git
cd startos-os/backend/
./install-sdk.sh
start-sdk init
```

## Cloning

Clone the project locally.

```
git clone https://github.com/kn0wmad/monerod-startos.git
cd monerod-startos
```

## Building

To build the **Monero** service, run the following commands:

```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --name multiarch --driver docker-container --use
docker buildx inspect --bootstrap
```

You should only run the above commands once to create a custom builder. Afterwards you will only need the below command to make the .s9pk file

```
make
```

## Installing (on StartOS)

Sideload from the web-UI:
System > Sideload Service

Sideload from CLI:
Run the following commands to determine successful install:

> :information_source: Change `adjective-noun.local` to your StartOS server's address.

Setup [SSH](https://docs.start9.com/latest/user-manual/overview/ssh) access to your StartOS server.
`scp` the `.s9pk` to any directory from your local machine.
Run the following command to install the package:

```
start-cli auth login
#Enter your StartOS server's master password, then run:
start-cli package install /path/to/monerod.s9pk
```

## Verify Install

Go to your StartOS Services page, select **Monero**, then configure and start the service.

## Support

Nostr: npub1yrtcvcqx0ev27ykxx4gh9s27wy3qa8zj6swal4g43k9wpwup4m9stheuas

Matrix (Tor-only): @kn0wmad:appbk73gzyuu6uieaw7beruw72muvzmmu6fgfrzs6q2rfrtf5iqsjryd.onion

**More channels coming in future**

## Donations

Monero:

`8ARx6ZDk43aNUEfw2inEinctoJNGwvZP1hssEpD1LgwY8ZKJVafxC4v6ZKcJE3LsdE29hWJ4UvFDUeYRoH4nf2K2RU24tRN`

### Bitcoin
Paynym: 
`+quietwind179`

BOLT12 Offer (Lightning Network): 
`lno1pg25getkypjx7mnpw35k7m3qgp4kuvrhd4skg93pq04aj923rc9pyr7z5tsf8hkp05lq7rcsdu2try95lh9umwhzde5qg`
