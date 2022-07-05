# EmbassyOS Wrapper for Monero

This project wraps the Monero daemon for EmbassyOS.  Monero is a private, secure, untraceable, decentralised digital currency. You are your bank, you control your funds, and nobody can trace your transfers unless you allow them to do so.  Learn more at https://www.getmonero.org/

## Dependencies

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)

## Clone and Build

```
git clone https://github.com/kn0wmad/monerod-wrapper.git
cd monerod-wrapper
make
```

## Sideload onto Embassy

Move the `.s9pk` to your device, replacing `xxxxxxxx` with your Embassy's unique id:

`scp monerod.s9pk start9@embassy-xxxxxxxx.local:~`

[SSH in](https://start9.com/latest/user-manual/ssh) and login to `embassy-cli` using your Embassy's master password:

`embassy-cli auth login`

Install monero

`embassy-cli package install monerod.s9pk`

## Donations

885A1RytMgJFYG8PniGivyDrnS5eT9ew8dZk1TvWHFZeMPNSHurGVUM1vEkj4DQtznbRuEfZRuUMNgQWr2dxAe12VfBpeKP