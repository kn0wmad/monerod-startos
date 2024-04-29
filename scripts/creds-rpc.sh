#!/bin/bash

BITMONERO_DIR=$(cat /data/.bitmonero/monero.conf |grep "^data-dir="|sed "s/^data-dir=\([^ #]*\).*/\1/")
RPC_CREDENTIALS=$(yq e '.rpc.credentials.enabled' ${BITMONERO_DIR}/start9/config.yaml)
if [ "$RPC_CREDENTIALS" == "enabled" ] ; then
 RPC_USERNAME=$(yq e '.rpc.credentials.username' ${BITMONERO_DIR}/start9/config.yaml)
 RPC_PASSWORD=$(yq e '.rpc.credentials.password' ${BITMONERO_DIR}/start9/config.yaml)
 CURL_RPC_CREDS="-u $RPC_USERNAME:$RPC_PASSWORD"
else
 CURL_RPC_CREDS=""
fi
