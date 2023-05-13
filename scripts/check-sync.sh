#!/bin/bash

STATUS=$(curl -s http://127.0.0.1:18081/get_info -H 'Content-Type: application/json')
STATUS_EXIT_CODE=$?
SYNCED=$(echo $STATUS | yq e '.synchronized')
BLOCKS_SYNCED=$(echo $STATUS | yq e '.height')
BLOCKS_TOTAL=$(echo $STATUS | yq e '.target_height')

if [[ $STATUS_EXIT_CODE -ne 0 ]]; then
    echo "Monero RPC is unreachable" >&2
    exit 61
elif [ "$SYNCED" = "true" ] ; then
    echo "Blockchain is synced"
    exit 0
elif [ "$SYNCED" = "false" ] ; then
    echo -n "Syncing Monero blockchain.  Initial sync may take several days. STATUS: Syncing block #$BLOCKS_SYNCED" >&2
    if [[ $BLOCKS_TOTAL -gt 0 ]] && [[ $BLOCKS_TOTAL -lt $BLOCKS_SYNCED ]] ; then
        SYNC_PROGRESS=$(expr ${BLOCKS_SYNCED}00 / $BLOCKS_TOTAL)
        echo -n " / $BLOCKS_TOTAL ($SYNC_PROGRESS%)" >&2
    fi
    exit 61
else
    echo "Error ascertaining blockchain status" >&2
    exit 61
fi
