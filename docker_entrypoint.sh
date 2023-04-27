#!/bin/bash

set -e

BITMONERO_DIR="/data/.bitmonero"
cp /root/monero.conf.template $BITMONERO_DIR/
new_conf_template="$BITMONERO_DIR/monero.conf.template"
new_conf="$BITMONERO_DIR/monero.conf"

export TOR_HOSTNAME=$(ip -4 route list match 0/0 | awk '{print $3}')
export TOR_PORT=9050
export MONERO_P2P_PORT=18080
export MONERO_RPC_PORT=18081
export MONERO_RPC_PORT_HS=18083
export MONERO_ANON_INBOUND_HOST="127.0.0.1" # monerod.embassy
export PEER_TOR_ADDRESS=$(yq e '.peer-tor-address' /data/.bitmonero/start9/config.yaml)
export RPC_LAN_ADDRESS=$(yq e '.rpc-lan-address' /data/.bitmonero/start9/config.yaml)
export RPC_TOR_ADDRESS=$(yq e '.rpc-tor-address' /data/.bitmonero/start9/config.yaml)

export ADV_P2P_MAXNUMOUTPEERS=$(yq e '.advanced.p2p.maxnumoutpeers' /data/.bitmonero/start9/config.yaml)
export ADV_P2P_MAXNUMINPEERS=$(yq e '.advanced.p2p.maxnuminpeers' /data/.bitmonero/start9/config.yaml)
export RATELIMIT_KBPSUP=$(yq e '.ratelimit.kbpsup' /data/.bitmonero/start9/config.yaml)
export RATELIMIT_KBPSDOWN=$(yq e '.ratelimit.kbpsdown' /data/.bitmonero/start9/config.yaml)
export ADV_TOR_DISABLERPCBAN=$(yq e '.advanced.tor.disablerpcban' /data/.bitmonero/start9/config.yaml)
export TXPOOL_MAXBYTES=$(yq e '.txpool.maxbytes' /data/.bitmonero/start9/config.yaml)
export ADV_TOR_TORONLY=$(yq e '.advanced.tor.toronly' /data/.bitmonero/start9/config.yaml)
export ADV_TOR_DANDELION=$(yq e '.advanced.tor.dandelion' /data/.bitmonero/start9/config.yaml)
export ADV_TOR_MAXSOCKSCONNS=$(yq e '.advanced.tor.maxsocksconns' /data/.bitmonero/start9/config.yaml)
export ADV_TOR_MAXONIONCONNS=$(yq e '.advanced.tor.maxonionconns' /data/.bitmonero/start9/config.yaml)
export ADV_P2P_DISABLEGOSSIP=$(yq e '.advanced.p2p.disablegossip' /data/.bitmonero/start9/config.yaml)
export ADV_P2P_PUBLICRPC=$(yq e '.advanced.p2p.publicrpc' /data/.bitmonero/start9/config.yaml)
export ADV_P2P_UPNP=$(yq e '.advanced.p2p.upnp' /data/.bitmonero/start9/config.yaml)
export ADV_P2P_STRICTNODES=$(yq e '.advanced.p2p.strictnodes' /data/.bitmonero/start9/config.yaml)
export ADV_PRUNING_MODE=$(yq e '.advanced.pruning' /data/.bitmonero/start9/config.yaml)
#export ADV_PRUNING_MODE=$(yq e '.advanced.pruning.mode' /data/.bitmonero/start9/config.yaml)
#export ADV_PRUNING_SYNCPRUNEDBLOCKS=$(yq e '.advanced.pruning.syncprunedblocks' /data/.bitmonero/start9/config.yaml)

# Properties Page
echo 'version: 2' > /data/.bitmonero/start9/stats.yaml
echo 'data:' >> /data/.bitmonero/start9/stats.yaml
echo '  Monero RPC Connection String (LAN):' >> /data/.bitmonero/start9/stats.yaml
echo '    type: string' >> /data/.bitmonero/start9/stats.yaml
echo '    value: "'"$RPC_LAN_ADDRESS:18081"'"' >> /data/.bitmonero/start9/stats.yaml
echo '    description: Address for connecting to the Monero RPC over LAN' >> /data/.bitmonero/start9/stats.yaml
echo '    copyable: true' >> /data/.bitmonero/start9/stats.yaml
echo '    masked: false' >> /data/.bitmonero/start9/stats.yaml
echo '    qr: true' >> /data/.bitmonero/start9/stats.yaml
echo '  Monero RPC Connection String (Tor):' >> /data/.bitmonero/start9/stats.yaml
echo '    type: string' >> /data/.bitmonero/start9/stats.yaml
echo '    value: "'"$RPC_TOR_ADDRESS:18081"'"' >> /data/.bitmonero/start9/stats.yaml
echo '    description: Address for connecting to the Monero RPC over Tor' >> /data/.bitmonero/start9/stats.yaml
echo '    copyable: true' >> /data/.bitmonero/start9/stats.yaml
echo '    masked: false' >> /data/.bitmonero/start9/stats.yaml
echo '    qr: true' >> /data/.bitmonero/start9/stats.yaml

#Replace the easily replacable variables in the config template
sed -i "s/ADV_P2P_MAXNUMOUTPEERS/$ADV_P2P_MAXNUMOUTPEERS/" $new_conf_template
sed -i "s/ADV_P2P_MAXNUMINPEERS/$ADV_P2P_MAXNUMINPEERS/" $new_conf_template
sed -i "s/RATELIMIT_KBPSUP/$RATELIMIT_KBPSUP/" $new_conf_template
sed -i "s/RATELIMIT_KBPSDOWN/$RATELIMIT_KBPSDOWN/" $new_conf_template
sed -i "s/TXPOOL_MAXBYTES/$TXPOOL_MAXBYTES/" $new_conf_template

###
#CONDITIONAL VARIABLES which we'll test for and then append to the end of the file:
###

#RPC BAN config:
if [ "$ADV_TOR_DISABLERPCBAN" = "true" ] ; then
 disable_rpc_ban="disable-rpc-ban=1              # Do not ban hosts on RPC errors. May help to prevent monerod from banning traffic originating from the Tor daemon."
 echo -e "\n# RPC BAN\n$disable_rpc_ban" >> $new_conf_template
fi

#TOR config:
if [ "$ADV_TOR_TORONLY" = "true" ] ; then
 echo -e "\n# TOR" >> $new_conf_template
 echo    "# Proxy for broadcasting/relaying transaction (does not fetch blocks)" >> $new_conf_template
 echo -n "tx-proxy=tor,TOR_HOSTNAME:TOR_PORT,ADV_TOR_MAXSOCKSCONNS" >> $new_conf_template
 if [ "$ADV_TOR_DANDELION" = "false" ] ; then
  echo ",disable_noise" >> $new_conf_template
 fi
 echo -e "\n# Use Tor's socks proxy for p2p traffic (note: --proxy cannot reach .onion nodes)" >> $new_conf_template
 echo    "proxy=TOR_HOSTNAME:TOR_PORT" >> $new_conf_template
 echo    "# Pad relayed transactions to next 1024 bytes to help defend against traffic volume analysis. This only makes sense if you are behind Tor or I2P." >> $new_conf_template
 echo    "pad-transactions=1" >> $new_conf_template
fi

#Gossip config:
if [ "$ADV_P2P_DISABLEGOSSIP" = "false" ] ; then
 echo -e "\n# GOSSIP" >> $new_conf_template
 echo "#Tell our peers not to gossip our node" >> $new_conf_template
 echo "hide-my-port=1" >> $new_conf_template
 echo "# Disable UPnP port mapping" >> $new_conf_template
 echo "igd=disabled" >> $new_conf_template
elif [ "$ADV_P2P_PUBLICRPC" = "true" ] ; then
 #RPC config:
 echo -e "\n# PUBLIC RPC" >> $new_conf_template
 echo "# Node advertisement: Requires --restricted-rpc, --rpc-bind-ip and --confirm-external-bind" >> $new_conf_template
 echo "# Advertise to users crawling the p2p network that they can use this node as a \"remote node\" for connecting their wallets." >> $new_conf_template
 echo "public-node=1" >> $new_conf_template
 if [ "$ADV_TOR_TORONLY" = "true" ] ; then
  echo "# Advertise onion as public remote node (Communicated to wallet clients that crawl to our p2p network port, when public-node=1)" >> $new_conf_template
  echo "anonymous-inbound=RPC_TOR_ADDRESS:MONERO_RPC_PORT,MONERO_ANON_INBOUND_HOST:MONERO_RPC_PORT_HS,ADV_TOR_MAXONIONCONNS" >> $new_conf_template
  echo "# Disable UPnP port mapping" >> $new_conf_template
  echo "igd=disabled" >> $new_conf_template
 #elif [ "ADV_P2P_UPNP" = "true" ] ; then
 # echo "#Enable UPnP port mapping" >> $new_conf_template
 # echo "igd=enabled" >> $new_conf_template
 fi
fi

sed -i "s/TOR_HOSTNAME/$TOR_HOSTNAME/g" $new_conf_template
sed -i "s/TOR_PORT/$TOR_PORT/g" $new_conf_template
sed -i "s/ADV_TOR_MAXSOCKSCONNS/$ADV_TOR_MAXSOCKSCONNS/g" $new_conf_template
sed -i "s/RPC_TOR_ADDRESS/$RPC_TOR_ADDRESS/g" $new_conf_template
sed -i "s/MONERO_RPC_PORT_HS/$MONERO_RPC_PORT_HS/g" $new_conf_template
sed -i "s/MONERO_RPC_PORT/$MONERO_RPC_PORT/g" $new_conf_template
sed -i "s/MONERO_ANON_INBOUND_HOST/$MONERO_ANON_INBOUND_HOST/g" $new_conf_template
sed -i "s/ADV_TOR_MAXONIONCONNS/$ADV_TOR_MAXONIONCONNS/g" $new_conf_template

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
num_custom_peers=$(yq e '.advanced.p2p.peer[]|length' /data/.bitmonero/start9/config.yaml | wc -l)
while [[ $i -le $num_custom_peers ]] ; do
 peer_hostname=$(yq e '.advanced.p2p.peer[$i].hostname' /data/.bitmonero/start9/config.yaml)
 peer_port=$(yq e '.advanced.p2p.peer[$i].port' /data/.bitmonero/start9/config.yaml)
 peer_priority=$(yq e '.advanced.p2p.peer[$i].prioritynode' /data/.bitmonero/start9/config.yaml)
 if [ "$ADV_P2P_STRICTNODES" = "true" ] ; then
  echo "add-exclusive-node=$peer_hostname:$peer_port" >> $new_conf_template
 else
  if [ "$peer_priority" = "true" ] ; then
   echo "add-priority-node=$peer_hostname:$peer_port" >> $new_conf_template
  else
   echo "add-node=$peer_hostname:$peer_port" >> $new_conf_template
  fi
  echo "" >> $new_conf_template
 fi
 i=$(expr $i + 1)
done

mv $new_conf_template $new_conf

chown -R monero:monero /data/.bitmonero

exec tini /usr/bin/sudo -u monero monerod --non-interactive --config-file=$new_conf