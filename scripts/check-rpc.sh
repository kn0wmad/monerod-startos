#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    curl -X POST http://monerod.embassy:18089/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_version"}' -H 'Content-Type: application/json' &>/dev/null
    RES=$?
    if [ $RES != 0 ]; then
        echo "Monero RPC is unreachable" >&2
        exit 1
    fi
fi



