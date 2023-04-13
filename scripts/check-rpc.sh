#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    CURL_OUTPUT=$(curl -so /dev/null -w "%{http_code}" http://127.0.0.1:18081/get_info -H 'Content-Type: application/json')
    EXIT_CODE=$?
    if [[ $CURL_OUTPUT -eq 200 ]] ; then
        echo "Monero RPC is ready for connections"
        exit 0
    elif [[ $EXIT_CODE -ne 0 ]] ; then
        echo "Monero RPC is unreachable"
        exit 61
    fi
fi
