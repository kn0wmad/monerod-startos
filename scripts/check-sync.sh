#!/bin/bash

source creds-rpc.sh
METHOD='get_info'
PARAMS='""'
STATUS=$(curl -X POST --digest $CURL_RPC_CREDS -s http://127.0.0.1:18089/json_rpc -H 'Content-Type: application/json' -d '{"jsonrpc":"2.0","id":"0","method":"'$METHOD'","params":'$PARAMS'}')
STATUS_EXIT_CODE=$?
SYNCED=$(echo $STATUS | yq e '.result.synchronized')
BLOCKS_SYNCED=$(echo $STATUS | yq e '.result.height')
BLOCKS_TOTAL=$(echo $STATUS | yq e '.result.target_height')

if [[ $STATUS_EXIT_CODE -ne 0 ]]; then
    echo "Monero RPC is unreachable" >&2
    exit 61
elif [ "$SYNCED" = "true" ] ; then
    echo "Blockchain is synced"
    exit 0
elif [ "$SYNCED" = "false" ] ; then
    echo -n "Syncing Monero blockchain.  Initial sync may take several days. STATUS: Syncing block #$BLOCKS_SYNCED" >&2
    #Get Synced status from log:
    SYNC_STATUS=$(ionice -c3 tail -10000 /data/.bitmonero/logs/monerod.log | grep "cryptonote_protocol_handler.inl:1686	Synced " | tail -1 | sed "s/\t/ /g" | tr -s " " | sed "s/.* Synced \([0-9]*\)\/\([0-9]*\) \(.*\)/\1:\2:\3/g")
    TOTAL_BLOCKS=$(echo $SYNC_STATUS | cut -d: -f2)
    ETA_DETAILS=$(echo $SYNC_STATUS | cut -d: -f3)
    ETA_DETAILS_CHARS=$(echo $ETA_DETAILS | wc -c)
    if [[ $TOTAL_BLOCKS -gt 0 ]] && [[ $TOTAL_BLOCKS -gt $BLOCKS_SYNCED ]] ; then
        echo -n " / $TOTAL_BLOCKS" >&2
        if [[ $ETA_DETAILS_CHARS -gt 10 ]] ; then
            echo -n " $ETA_DETAILS" >&2
        else
            SYNC_PROGRESS=$(expr ${BLOCKS_SYNCED}00 / $TOTAL_BLOCKS)
            echo -n " / $BLOCKS_TOTAL ($SYNC_PROGRESS%)" >&2
        fi
    elif [[ $BLOCKS_TOTAL -gt 0 ]] && [[ $BLOCKS_TOTAL -gt $BLOCKS_SYNCED ]] ; then
        SYNC_PROGRESS=$(expr ${BLOCKS_SYNCED}00 / $BLOCKS_TOTAL)
        echo -n " / $BLOCKS_TOTAL ($SYNC_PROGRESS%)" >&2
    fi
    exit 61
else
    echo "Error ascertaining blockchain status" >&2
    exit 61
fi
