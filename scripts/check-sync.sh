#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    STATUS=$(monerod status | grep -o 'Height.*mainnet')
    STATUS_EXIT_CODE=$?
    SYNC_PROGRESS=$(echo $STATUS | sed "s/^Height: \([0-9]*\)\/\([0-9]*\) (\([0-9]*\)\.\([0-9]\)%.*/\3/")
    if [[ $SYNC_PROGRESS -eq 100 ]] ; then
        echo "Success: Monero is synced with the network"
        exit 0
    elif [[ $STATUS_EXIT_CODE -ne 0 ]]; then
        echo "Monero RPC is unreachable"
        exit 1
    elif [[ $SYNC_PROGRESS -lt 100 ]] && [[ $SYNC_PROGRESS -ge 0 ]]
        echo "Syncing to Monero blockchain.  Initial sync may take several days. STATUS: $STATUS"
        exit $SYNC_PROGRESS
    else
        echo "Error ascertaining blockchain status"
        exit 61
    fi
fi