# Haveno (RetoSwap)
Haveno (RetoSwap) is a peer-to-peer exchange (forked from Bisq)

## Available For:
- Linux
- Mac
- Windows

## Setup
1. Download [RetoSwap](https://retoswap.com/).
1. Open RetoSwap and navigate to Settings -> Network Info
1. Select "Always" under "Use Tor for Monero network"
1. Select "Use custom Monero nodes" under "Monero nodes to connect to"
1. Copy your "Restricted RPC URL (Tor)" connection string from StartOS -> Monero -> Properties.
1. Paste into the "Use custom Monero nodes" field, and remove the protocol prefix `http://`. Leave the `:18089` port suffix as is.
1. When you click away from this field, you will be prompted to shut down and restart RetoSwap, do so.
1. That's it!  On the next launch, you will view the "Connected" status next to your node address.

|Note: You can add more nodes in the same fashion for redundancy.  Using only tor (onion) addresses, is highly recommended
