# EmbassyOS Wrapper for Monero
This project wraps the Monero daemon for EmbassyOS.  Monero is a private, secure, untraceable, decentralised digital currency. You are your bank, you control your funds, and nobody can trace your transfers unless you allow them to do so.  Learn more at https://www.getmonero.org/

## Dependencies
- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)

## Build enviroment
Prepare your EmbassyOS build enviroment. In this example we are using Ubuntu 20.04.

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
```
sudo wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\
    sudo chmod +x /usr/bin/yq
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
8. Build and install embassy-sdk
```
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
cd embassy-os/backend/
./install-sdk.sh
embassy-sdk init
```

## Cloning
Clone the project locally. 
```
git clone https://github.com/Start9Labs/monerod-wrapper.git
cd monerod-wrapper
```

## Building
To build the **Monero** service, run the following command:

```
make
```

## Installing (on Embassy)
Run the following commands to determine successful install:
> :information_source: Change `embassy-xxxxxxxx.local` to your Embassy address


```
embassy-cli auth login
#Enter your embassy password
embassy-cli --host https://embassy-xxxxxxxx.local package install monerod.s9pk
```
**Tip:** You can also install the monerod.s9pk by sideloading: **Embassy -> Settings -> Sideload Service**
## Verify Install
Go to your Embassy Services page, select **Monero**, then configure and start the service.

## Support
Nostr: npub1yrtcvcqx0ev27ykxx4gh9s27wy3qa8zj6swal4g43k9wpwup4m9stheuas
Matrix (Tor-only): @kn0wmad:appbk73gzyuu6uieaw7beruw72muvzmmu6fgfrzs6q2rfrtf5iqsjryd.onion

**More channels coming soon**

## Donations
Monero (kn0wmad):
`885A1RytMgJFYG8PniGivyDrnS5eT9ew8dZk1TvWHFZeMPNSHurGVUM1vEkj4DQtznbRuEfZRuUMNgQWr2dxAe12VfBpeKP`
