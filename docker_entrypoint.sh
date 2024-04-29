#!/bin/bash

BITMONERO_DIR="/data/.bitmonero"
BITMONERO_DIR_ESC=$(echo "$BITMONERO_DIR" | sed "s/\//\\\\\\//g")
MONERO_LOGS_DIR=$(echo "$BITMONERO_DIR/logs")
MONERO_WALLET_DIR=$(echo "$BITMONERO_DIR/wallets")
mkdir -p $MONERO_LOGS_DIR $MONERO_WALLET_DIR
MONERO_LOG="$MONERO_LOGS_DIR/monerod.log"
MONERO_LOG_ESC=$(echo "$MONERO_LOG" | sed "s/\//\\\\\\//g")
MONERO_WALLET_RPC_LOG="monero-wallet-rpc.log"
conf_template="/root/monero.conf.template"
new_conf_template="$BITMONERO_DIR/monero.conf.template"
cp $conf_template $new_conf_template
new_conf="$BITMONERO_DIR/monero.conf"

MONERO_LAN_HOSTNAME="monerod.embassy"
MONEROD_LOCAL_HOST="127.0.0.1"
MONEROD_BIND_IP="0.0.0.0"
TOR_SOCKS_PROXY_HOST=$(ip -4 route list match 0/0 | awk '{print $3}')
TOR_PORT=9050
STARTOS_REVPROXY_PORT=443
MONERO_P2P_PORT=18080
MONERO_RPC_PORT=18081
MONERO_ZMQ_PORT=18082
MONERO_ZMQ_PUBSUB_PORT=18083
MONERO_P2P_PORT_ANONIN=18080
MONERO_P2P_PORT_LOCAL_BIND=18088
MONERO_RPC_PORT_RESTRICTED=18089
MONERO_RPC_PORT_WALLET_RPC=28088
PEER_TOR_ADDRESS=$(yq e '.peer-tor-address' ${BITMONERO_DIR}/start9/config.yaml)
RPC_LAN_ADDRESS=$(yq e '.rpc-lan-address' ${BITMONERO_DIR}/start9/config.yaml)
RPC_TOR_ADDRESS=$(yq e '.rpc-tor-address' ${BITMONERO_DIR}/start9/config.yaml)
RPC_LAN_ADDRESS_RESTRICTED=$(yq e '.rpc-lan-address-restricted' ${BITMONERO_DIR}/start9/config.yaml)
RPC_TOR_ADDRESS_RESTRICTED=$(yq e '.rpc-tor-address-restricted' ${BITMONERO_DIR}/start9/config.yaml)
RPC_CREDENTIALS=$(yq e '.rpc.rpc-credentials.enabled' ${BITMONERO_DIR}/start9/config.yaml)
if [ "$RPC_CREDENTIALS" == "enabled" ] ; then
 RPC_USERNAME=$(yq e '.rpc.rpc-credentials.username' ${BITMONERO_DIR}/start9/config.yaml)
 RPC_PASSWORD=$(yq e '.rpc.rpc-credentials.password' ${BITMONERO_DIR}/start9/config.yaml)
fi
RPC_LAN_ADDRESS_WALLET=$(yq e '.rpc-lan-address-wallet' ${BITMONERO_DIR}/start9/config.yaml)
RPC_TOR_ADDRESS_WALLET=$(yq e '.rpc-tor-address-wallet' ${BITMONERO_DIR}/start9/config.yaml)
RPC_WALLET_CREDENTIALS=$(yq e '.rpc.wallet-rpc-credentials.enabled' ${BITMONERO_DIR}/start9/config.yaml)
if [ "$RPC_WALLET_CREDENTIALS" == "enabled" ] ; then
 RPC_WALLET_USERNAME=$(yq e '.rpc.wallet-rpc-credentials.username' ${BITMONERO_DIR}/start9/config.yaml)
 RPC_WALLET_PASSWORD=$(yq e '.rpc.wallet-rpc-credentials.password' ${BITMONERO_DIR}/start9/config.yaml)
fi
ZMQ=$(yq e '.advanced.zmq' ${BITMONERO_DIR}/start9/config.yaml)
ZMQ_TOR_ADDRESS=$(yq e '.zmq-tor-address' ${BITMONERO_DIR}/start9/config.yaml)
ZMQ_PUBSUB_LAN_ADDRESS=$(yq e '.advanced.zmq-pubsub-lan-address' ${BITMONERO_DIR}/start9/config.yaml)
ZMQ_PUBSUB_TOR_ADDRESS=$(yq e '.advanced.zmq-pubsub-tor-address' ${BITMONERO_DIR}/start9/config.yaml)
ADV_P2P_MAXNUMOUTPEERS=$(yq e '.advanced.p2p.maxnumoutpeers' ${BITMONERO_DIR}/start9/config.yaml)
ADV_P2P_MAXNUMINPEERS=$(yq e '.advanced.p2p.maxnuminpeers' ${BITMONERO_DIR}/start9/config.yaml)
RATELIMIT_KBPSUP=$(yq e '.ratelimit.kbpsup' ${BITMONERO_DIR}/start9/config.yaml)
RATELIMIT_KBPSDOWN=$(yq e '.ratelimit.kbpsdown' ${BITMONERO_DIR}/start9/config.yaml)
ADV_TOR_RPCBAN=$(yq e '.advanced.tor.rpcban' ${BITMONERO_DIR}/start9/config.yaml)
TXPOOL_MAXBYTES=$(yq e '.txpool.maxbytes' ${BITMONERO_DIR}/start9/config.yaml)000000
ADV_TOR_TORONLY=$(yq e '.advanced.tor.toronly' ${BITMONERO_DIR}/start9/config.yaml)
ADV_TOR_DANDELION=$(yq e '.advanced.tor.dandelion' ${BITMONERO_DIR}/start9/config.yaml)
ADV_TOR_MAXSOCKSCONNS=$(yq e '.advanced.tor.maxsocksconns' ${BITMONERO_DIR}/start9/config.yaml)
ADV_TOR_MAXONIONCONNS=$(yq e '.advanced.tor.maxonionconns' ${BITMONERO_DIR}/start9/config.yaml)
ADV_P2P_GOSSIP=$(yq e '.advanced.p2p.letneighborsgossip' ${BITMONERO_DIR}/start9/config.yaml)
ADV_P2P_PUBLICRPC=$(yq e '.advanced.p2p.publicrpc' ${BITMONERO_DIR}/start9/config.yaml)
ADV_P2P_STRICTNODES=$(yq e '.advanced.p2p.strictnodes' ${BITMONERO_DIR}/start9/config.yaml)
#export ADV_P2P_UPNP=$(yq e '.advanced.p2p.upnp' ${BITMONERO_DIR}/start9/config.yaml)
ADV_PRUNING_MODE=$(yq e '.advanced.pruning' ${BITMONERO_DIR}/start9/config.yaml)
#ADV_PRUNING_MODE=$(yq e '.advanced.pruning.mode' ${BITMONERO_DIR}/start9/config.yaml)
#ADV_PRUNING_SYNCPRUNEDBLOCKS=$(yq e '.advanced.pruning.syncprunedblocks' ${BITMONERO_DIR}/start9/config.yaml)
INT_ANN_BLOCKS_TO_BTCPAY=$(yq e '.integrations.blocknotify.btcpayserver' ${BITMONERO_DIR}/start9/config.yaml)

# Properties Page
echo 'version: 2' > ${BITMONERO_DIR}/start9/stats.yaml
echo 'data:' >> ${BITMONERO_DIR}/start9/stats.yaml
if [ "$RPC_CREDENTIALS" == "enabled" ] ; then
 RPC_USER_PASS="${RPC_USERNAME}:${RPC_PASSWORD}@"
 echo '  RPC Username:' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$RPC_WALLET_USERNAME"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo "    description: Username for connecting to the Monero daemon's unrestricted RPC Interface" >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '  RPC Password:' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$RPC_WALLET_PASSWORD"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo "    description: Password for connecting to the Monero daemon's unrestricted RPC Interface" >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: false' >> ${BITMONERO_DIR}/start9/stats.yaml
else
 RPC_USER_PASS=""
fi
echo '  Restricted RPC URL (LAN):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_USER_PASS$RPC_LAN_ADDRESS_RESTRICTED:$STARTOS_REVPROXY_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo "    description: Connection string for accessing the Monero daemon's RPC over LAN" >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '  Restricted RPC URL (Tor):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_USER_PASS$RPC_TOR_ADDRESS_RESTRICTED:$MONERO_RPC_PORT_RESTRICTED"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    description: Connection string for accessing the Monero RPC over Tor' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '  Unrestricted RPC URL (LAN):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_USER_PASS$RPC_LAN_ADDRESS:$STARTOS_REVPROXY_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    description: Connection string for accessing the unrestricted Monero RPC over LAN' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '  Unrestricted RPC URL (Tor):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_USER_PASS$RPC_TOR_ADDRESS:$MONERO_RPC_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    description: Connection string for accessing the unrestricted Monero RPC via Tor' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '  Unrestricted RPC URL (Internal):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_USER_PASS$MONERO_LAN_HOSTNAME:$MONERO_RPC_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo "    description: Connection string for accessing the unrestricted Monero RPC from another service's container." >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
if [ "$RPC_WALLET_CREDENTIALS" == "enabled" ] ; then
 RPC_WALLET_USER_PASS="${RPC_WALLET_USERNAME}:${RPC_WALLET_PASSWORD}@"
 echo '  Wallet RPC Username:' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$RPC_WALLET_USERNAME"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    description: Username for connecting to the unrestricted Monero RPC' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '  Wallet RPC Password:' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$RPC_WALLET_PASSWORD"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    description: Password for connecting to the unrestricted Monero RPC' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 #Create a token for use later when invoking monero-wallet-rpc:
 RPC_WALLET_USER_PASS_FLAG="--rpc-login $RPC_WALLET_USERNAME:$RPC_WALLET_PASSWORD"
else
 RPC_WALLET_USER_PASS=""
 RPC_WALLET_USER_PASS_FLAG=""
fi
echo '  Wallet RPC URL (LAN):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_WALLET_USER_PASS$RPC_LAN_ADDRESS_WALLET:$STARTOS_REVPROXY_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo "    description: Address for connecting to the Monero wallet RPC interface on the LAN" >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '  Wallet RPC URL (Tor):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_WALLET_USER_PASS$RPC_LAN_ADDRESS_WALLET:$MONERO_RPC_PORT_WALLET_RPC"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo "    description: Address for connecting to the Monero wallet RPC interface via Tor" >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '  Wallet RPC URL (Internal):' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    value: "'"https://$RPC_WALLET_USER_PASS$RPC_LAN_ADDRESS_WALLET:$MONERO_RPC_PORT_WALLET_RPC"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
echo "    description: Address for connecting to the Monero wallet RPC interface from another StartOS service" >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
if [ "$ZMQ" == "true" ] ; then
 echo '  ZMQ Interface (Tor):' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$ZMQ_TOR_ADDRESS:$MONERO_ZMQ_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    description: ZMQ interface address for receiving transaction and block notifications via Tor' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '  ZMQ Interface (Internal):' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$MONERO_LAN_HOSTNAME:$MONERO_ZMQ_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo "    description: ZMQ interface address for receiving transaction and block notifications from another service's container" >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '  ZMQ Pub-Sub Interface (Tor):' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$ZMQ_TOR_ADDRESS:$MONERO_ZMQ_PUBSUB_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    description: ZMQ interface address for receiving transaction and block notifications via Tor' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '  ZMQ Pub-Sub Interface (Internal):' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    type: string' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    value: "'"$MONERO_LAN_HOSTNAME:$MONERO_ZMQ_PUBSUB_PORT"'"' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo "    description: ZMQ interface address for receiving transaction and block notifications from another service's container" >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    copyable: true' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    masked: false' >> ${BITMONERO_DIR}/start9/stats.yaml
 echo '    qr: true' >> ${BITMONERO_DIR}/start9/stats.yaml
fi

#Replace the easily replacable variables in the config template
sed -i "s/BITMONERO_DIR/$BITMONERO_DIR_ESC/" $new_conf_template
sed -i "s/MONERO_LOG/$MONERO_LOG_ESC/" $new_conf_template
sed -i "s/ADV_P2P_MAXNUMOUTPEERS/$ADV_P2P_MAXNUMOUTPEERS/" $new_conf_template
sed -i "s/ADV_P2P_MAXNUMINPEERS/$ADV_P2P_MAXNUMINPEERS/" $new_conf_template
sed -i "s/RATELIMIT_KBPSUP/$RATELIMIT_KBPSUP/" $new_conf_template
sed -i "s/RATELIMIT_KBPSDOWN/$RATELIMIT_KBPSDOWN/" $new_conf_template
sed -i "s/TXPOOL_MAXBYTES/$TXPOOL_MAXBYTES/" $new_conf_template

###
#CONDITIONAL VARIABLES which we'll test for and then append to the end of the config file:
###

#ZMQ config:
echo -e "\n# ZMQ Interface" >> $new_conf_template
if [ "$ZMQ" = "false" ] ; then
 zmq_config="no-zmq=1                        # We don't use the zmq server. Disabling to \"limit attack surface\""
else
 zmq_config="zmq-rpc-bind-ip=$MONEROD_BIND_IP     # ZMQ listens on all interfaces inside the container"
 zmq_config="$zmq_config\nzmq-rpc-bind-port=$MONERO_ZMQ_PORT     # ZMQ Port"
 zmq_config="$zmq_config\nzmq-pub=tcp://$MONEROD_BIND_IP:$MONERO_ZMQ_PUBSUB_PORT # ZMQ Pub-Sub Port"
fi
echo -e "$zmq_config" >> $new_conf_template

#RPC config:
if [ "$RPC_CREDENTIALS" == "enabled" ] ; then
 echo -e "\n# RPC Credentials" >> $new_conf_template
 echo "rpc-login=$RPC_USERNAME:$RPC_PASSWORD    # Require a username and password to access the unrestricted RPC interface" >> $new_conf_template
fi
if [ "$ADV_TOR_RPCBAN" = "false" ] ; then
 disable_rpc_ban="disable-rpc-ban=1              # Do not ban hosts on RPC errors. May help prevent monerod from banning traffic originating from the Tor daemon."
 echo -e "\n# RPC Ban\n$disable_rpc_ban" >> $new_conf_template
fi

#TOR config:
if [ "$ADV_TOR_TORONLY" = "true" ] ; then
 echo -e "\n# TOR" >> $new_conf_template
 echo    "# Proxy for broadcasting/relaying transaction (does not fetch blocks)" >> $new_conf_template
 echo -n "tx-proxy=tor,TOR_SOCKS_PROXY_HOST:TOR_PORT,ADV_TOR_MAXSOCKSCONNS" >> $new_conf_template
 if [ "$ADV_TOR_DANDELION" = "false" ] ; then
  echo ",disable_noise" >> $new_conf_template
 fi
 echo -e "\n# Use Tor's socks proxy for p2p traffic (note: --proxy cannot reach .onion nodes)" >> $new_conf_template
 echo    "proxy=TOR_SOCKS_PROXY_HOST:TOR_PORT" >> $new_conf_template
 echo    "# Pad relayed transactions to next 1024 bytes to help defend against traffic volume analysis. This only makes sense if you are behind Tor or I2P." >> $new_conf_template
 echo    "pad-transactions=1" >> $new_conf_template
fi

#Gossip config:
if [ "$ADV_P2P_GOSSIP" = "false" ] ; then
 echo -e "\n# GOSSIP" >> $new_conf_template
 echo "#Tell our peers not to gossip our node" >> $new_conf_template
 echo "hide-my-port=1" >> $new_conf_template
 echo "# Disable UPnP port mapping" >> $new_conf_template
 echo "igd=disabled" >> $new_conf_template
elif [ "$ADV_P2P_PUBLICRPC" = "true" ] ; then
 #RPC config:
 echo -e "\n# EXTERNAL CONNECTIONS" >> $new_conf_template
 echo "# Node advertisement: Requires --restricted-rpc, --rpc-bind-ip and --confirm-external-bind" >> $new_conf_template
 echo "# Advertise to wallets crawling the p2p network that they can use this node as a \"remote node\" for connecting their wallets." >> $new_conf_template
 echo "public-node=1" >> $new_conf_template
 if [ "$ADV_TOR_TORONLY" = "true" ] ; then
  echo "# Advertise our onion as the our reachable p2p port for incoming connections" >> $new_conf_template
  echo "anonymous-inbound=PEER_TOR_ADDRESS:MONERO_P2P_PORT_ANONIN,MONEROD_LOCAL_HOST:MONERO_P2P_PORT_LOCAL_BIND,ADV_TOR_MAXONIONCONNS" >> $new_conf_template
  echo "# Disable UPnP port mapping" >> $new_conf_template
  echo "igd=disabled" >> $new_conf_template
 #elif [ "ADV_P2P_UPNP" = "true" ] ; then
 # echo "#Enable UPnP port mapping" >> $new_conf_template
 # echo "igd=enabled" >> $new_conf_template
 fi
fi

sed -i "s/MONEROD_BIND_IP/$MONEROD_BIND_IP/g" $new_conf_template
sed -i "s/PEER_TOR_ADDRESS/$PEER_TOR_ADDRESS/g" $new_conf_template
sed -i "s/TOR_PORT/$TOR_PORT/g" $new_conf_template
sed -i "s/ADV_TOR_MAXSOCKSCONNS/$ADV_TOR_MAXSOCKSCONNS/g" $new_conf_template
sed -i "s/RPC_TOR_ADDRESS_RESTRICTED/$RPC_TOR_ADDRESS_RESTRICTED/g" $new_conf_template
sed -i "s/RPC_TOR_ADDRESS/$RPC_TOR_ADDRESS/g" $new_conf_template
sed -i "s/MONERO_P2P_PORT_LOCAL_BIND/$MONERO_P2P_PORT_LOCAL_BIND/g" $new_conf_template
sed -i "s/MONERO_P2P_PORT_ANONIN/$MONERO_P2P_PORT_ANONIN/g" $new_conf_template
sed -i "s/MONERO_P2P_PORT/$MONERO_P2P_PORT/g" $new_conf_template
sed -i "s/MONERO_RPC_PORT_RESTRICTED/$MONERO_RPC_PORT_RESTRICTED/g" $new_conf_template
sed -i "s/MONERO_RPC_PORT/$MONERO_RPC_PORT/g" $new_conf_template
sed -i "s/MONEROD_LOCAL_HOST/$MONEROD_LOCAL_HOST/g" $new_conf_template
sed -i "s/ADV_TOR_MAXONIONCONNS/$ADV_TOR_MAXONIONCONNS/g" $new_conf_template
sed -i "s/TOR_SOCKS_PROXY_HOST/$TOR_SOCKS_PROXY_HOST/g" $new_conf_template

#PRUNING config:
if [ "$ADV_PRUNING_MODE" = "true" ] ; then
 echo -e "\n# PRUNING\nprune-blockchain=1" >> $new_conf_template
 #if [ "$ADV_PRUNING_SYNCPRUNEDBLOCKS" = "true" ] ; then
 # echo "sync-pruned-blocks=1" >> $new_conf_template
 #fi
fi
 
#CUSTOM NODES config:
echo -e "\n# CUSTOM NODES" >> $new_conf_template
i=1
num_custom_peers=$(yq e '.advanced.p2p.peer[]|length' ${BITMONERO_DIR}/start9/config.yaml | wc -l)
while [[ $i -le $num_custom_peers ]] ; do
 peer_hostname=$(yq e '.advanced.p2p.peer[$i].hostname' ${BITMONERO_DIR}/start9/config.yaml)
 peer_port=$(yq e '.advanced.p2p.peer[$i].port' ${BITMONERO_DIR}/start9/config.yaml)
 peer_priority=$(yq e '.advanced.p2p.peer[$i].prioritynode' ${BITMONERO_DIR}/start9/config.yaml)
 if [ "$ADV_P2P_STRICTNODES" = "true" ] ; then
  echo "add-exclusive-node=$peer_hostname:$peer_port" >> $new_conf_template
 else
  if [ "$peer_priority" = "true" ] ; then
   echo "add-priority-node=$peer_hostname:$peer_port" >> $new_conf_template
  else
   echo "add-peer=$peer_hostname:$peer_port" >> $new_conf_template
  fi
  echo "" >> $new_conf_template
 fi
 i=$(expr $i + 1)
done

#If the user has enabled BTCPayServer integration, send block notifications there
if [ "$INT_ANN_BLOCKS_TO_BTCPAY" == "true" ] ; then
 btcpay_integration='block-notify="/usr/bin/curl -so /dev/null -X GET http://btcpayserver.embassy:23001/monerolikedaemoncallback/block?cryptoCode=xmr&hash=%s"'
 echo -e "\n# BLOCK NOTIFICATIONS\n${btcpay_integration}" >> $new_conf_template
fi

chown -R monero:monero $BITMONERO_DIR
mv $new_conf_template $new_conf
chown root:monero $new_conf
chmod 640 $new_conf

exec echo /usr/bin/sudo -u monero monero-wallet-rpc --non-interactive --trusted-daemon --daemon-address http://$RPC_USER_PASS$MONEROD_LOCAL_HOST:$MONERO_RPC_PORT $RPC_WALLET_USER_PASS_FLAG --confirm-external-bind --rpc-bind-ip=$MONEROD_BIND_IP --rpc-bind-port=$MONERO_RPC_PORT_WALLET_RPC --wallet-dir=$MONERO_WALLET_DIR --max-log-files=2 --log-file=$MONERO_LOGS_DIR/$MONERO_WALLET_RPC_LOG &

exec /usr/bin/sudo -u monero monerod --non-interactive --config-file=$new_conf | tee $MONERO_LOG
