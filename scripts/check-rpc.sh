#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    source creds-rpc.sh
    METHOD='get_info'
    PARAMS='""'
    CURL_OUTPUT=$(curl -so /dev/null -w "%{http_code}" -X POST --digest $CURL_RPC_CREDS -s http://127.0.0.1:18081/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"'$METHOD'","params":'$PARAMS'}')
    EXIT_CODE=$?
    if [[ $CURL_OUTPUT -eq 200 ]] ; then
        echo "Monero RPC is ready for connections"
        exit 0
    elif [[ $EXIT_CODE -ne 0 ]] ; then
        echo "Monero RPC is unreachable"
        exit 61
    fi
fi
