#!/bin/bash

set -euo pipefail

export HOST_IP=$(ip -4 route list match 0/0 | awk '{print $3}')
export PEER_TOR_ADDRESS=$(yq e '.peer-tor-address' /root/.monero/start9/config.yaml)
export RPC_TOR_ADDRESS=$(yq e '.rpc-tor-address' /root/.monero/start9/config.yaml)

# chown -R monero:monero /root/.bitmonero

exec /usr/local/bin/monerod --config-file /etc/monero/monero.conf --non-interactive --no-zmq --p2p-bind-ip=0.0.0.0 --p2p-bind-port=18080

# --non-interactive --rpc-restricted-bind-ip=0.0.0.0 --rpc-restricted-bind-port=18089 --no-igd --no-zmq --enable-dns-blocklist