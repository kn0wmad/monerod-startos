#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    STATUS=$(monerod status | grep -o 'Height.*mainnet') &>/dev/null
    SYNCRES=$?
    if [ $SYNCRES != 0 ]; then
        echo "Monero RPC is unreachable" >&2
        exit 1
    else
        echo $STATUS >&2
        exit 61
    fi
fi