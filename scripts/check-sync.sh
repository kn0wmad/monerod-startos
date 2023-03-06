#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 5500)); then
    exit 60
else
    #STATUS=$(monerod --non-interactive --config-file /data/.bitmonero/monero.conf status | grep -o 'Height.*mainnet')
    STATUS=$(curl -s http://127.0.0.1:18081/get_info -H 'Content-Type: application/json')
    STATUS_EXIT_CODE=$?
    #SYNC_STATUS=$(echo $STATUS | sed "s/^Height: \([0-9]*\)\/\([0-9]*\) (\([0-9]*\)\.\([0-9]\)%.*/\1:\2:\3/")
    #SYNC_PROGRESS=$(echo $SYNC_STATUS | cut -d: -f3 | cut -d'.' -f1)
    SYNCED=$(echo $STATUS | yq e '.synchronized')
    #BLOCKS_TOTAL=$(echo $SYNC_STATUS | cut -d: -f2)
    BLOCKS_SYNCED=$(echo $STATUS | yq e '.height')
    BLOCKS_TOTAL=$(echo $STATUS | yq e '.target_height')
    if [ "$SYNCED" = "false" ] ; then
     echo -n "Syncing Monero blockchain.  Initial sync may take several days.  STATUS: Processing block #$BLOCKS_SYNCED"
     if [[ $BLOCKS_TOTAL -gt 0 ]] ; then
      SYNC_PROGRESS=$(expr ${BLOCKS_SYNCED}00/$BLOCKS_TOTAL)
      echo "/${BLOCKS_TOTAL} ($SYNC_PROGRESS%)"
     fi     
     exit 61
    elif [[ $STATUS_EXIT_CODE -ne 0 ]]; then
        echo "Monero RPC is unreachable"
        exit 61
    else
        echo "Error ascertaining blockchain status"
        exit 61
    fi
fi
