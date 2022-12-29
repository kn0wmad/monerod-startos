#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    CURL_OUTPUT=$(curl -sw "%{http_code}" http://monerod.embassy:18081/json_rpc -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json')
    EXIT_CODE=$?
    if [[ $CURL_OUTPUT -eq 200 ]] ; then
        echo "Monero RPC is ready for connections"
        exit 0
    elif [[ $EXIT_CODE -ne 0 ]] ; then
        echo "Monero RPC is unreachable"
        exit 1
    fi
fi
