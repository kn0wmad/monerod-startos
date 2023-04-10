# Monero-GUI Wallet (Desktop)
## Available For:
- Linux
- Mac
- Windows
## Setup
| PLEASE NOTE: This guide assumes that you have setup [LAN](https://docs.start9.com/latest/user-manual/connecting/connecting-lan/lan-os/) and/or [Tor](https://docs.start9.com/latest/user-manual/connecting/connecting-tor/tor-os/index) connectivity on your desktop before continuing.  Currently LAN is recommended for local (home/office) use, and Tor is recommended for remote access.

1. Download for your OS - https://www.getmonero.org/downloads/
1. Go to Setting -> Node -> Remote Node, then click "+ Add Remote Node"
1. Copy your RPC connection string (LAN or Tor) from your server's Monero page -> Interfaces and paste it in as a new line (or as the only line, removing others, to only use your private node), then click OK
    - Be sure that the format is `yourUniqueString.local` (LAN) or `yourUniqueString.onion` (Tor)
1. Enter the port `18081`, "Mark as Trusted Daemon," then click OK
    - If you are using Tor, select the "Interface" tab, select "Socks5 Proxy," and then point to your system daemon at `127.0.0.1` (Host), `9050` (Port)
1. That's it, you're ready to use Feather Wallet with your own Monero node!