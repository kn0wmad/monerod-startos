#!/bin/bash

set -ea

# set -euo pipefail

export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
export PEER_TOR_ADDRESS=$(yq e '.peer-tor-address' /root/.bitmonero/start9/config.yaml)
export RPC_TOR_ADDRESS=$(yq e '.rpc-tor-address' /root/.bitmonero/start9/config.yaml)

exec tini monerod --non-interactive --rpc-restricted-bind-ip=0.0.0.0 --rpc-restricted-bind-port=18089 --public-node --no-igd --no-zmq --enable-dns-blocklist

# --anonymous-inbound=PEER_TOR_ADDRESS:18083,monerod.embassy:18083,32
# tx-proxy=tor,127.0.0.1:9050