#!/bin/bash

set -euo pipefail

export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
export PEER_TOR_ADDRESS=$(yq e '.peer-tor-address' /root/.bitmonero/start9/config.yaml)
export RPC_TOR_ADDRESS=$(yq e '.rpc-tor-address' /root/.bitmonero/start9/config.yaml)

exec tini /usr/local/bin/monerod --non-interactive --enable-dns-blocklist
