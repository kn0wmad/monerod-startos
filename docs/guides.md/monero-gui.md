# Monero-GUI Wallet (Desktop)

## Available For:

- Linux
- Mac
- Windows

## Setup

| PLEASE NOTE: This guide assumes that you have setup [LAN](https://docs.start9.com/0.3.5.x/user-manual/trust-ca) and/or [Tor](https://docs.start9.com/0.3.5.x/user-manual/connecting-tor#using-native-apps) connectivity on your desktop before continuing. Currently LAN is recommended for local (home/office) use, and Tor is recommended for remote access

1. Download for your OS - https://www.getmonero.org/downloads/
1. Go to Setting -> Node -> Remote Node, then click "+ Add Remote Node"
1. Copy your "Restricted RPC URL" connection string (LAN or Tor) from your server's Monero page -> Interfaces and paste it in as a new line (or as the only line, removing others, to only use your private node), then click OK
   - Be sure that the format is `yourUniqueString.local` (LAN) or `yourUniqueString.onion` (Tor)
1. Enter the port `443` if you are using Restricted RPC URL (LAN), `18089` if you are using Restricted RPC URL (Tor), and "Mark as Trusted Daemon," then click OK
   - If you are using Tor, select the "Interface" tab, select "Socks5 Proxy," and then point to your system daemon at `127.0.0.1` (Host), `9050` (Port)
1. That's it, you're ready to use Feather Wallet with your own Monero node!
