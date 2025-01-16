# Feather Wallet (Desktop)

## Available For:

- Linux
- Mac
- Windows

## Setup

| PLEASE NOTE: This guide assumes that you have setup [LAN](https://docs.start9.com/0.3.5.x/user-manual/trust-ca) and/or [Tor](https://docs.start9.com/0.3.5.x/user-manual/connecting-tor#using-native-apps) connectivity on your desktop before continuing. Currently LAN is recommended for local (home/office) use, and Tor is recommended for remote access.

1. Download for your OS - https://featherwallet.org/download/
1. Go to File -> Settings -> Network (or click the network icon in the bottom right of the application), then click "Add Custom Node(s)"
1. Copy your "Restricted RPC URL" connection string (LAN or Tor) from your server's Monero page -> Properties and paste it in as a new line (or as the only line, removing others, to only use your private node), then click OK
   - Be sure that the format is `yourUniqueString.local:18089` (LAN) or `yourUniqueString.onion:18089` (Tor)
   - If you are using LAN, select the 'Proxy' tab and select "None." Click OK
   - If you are using Tor, select the 'Proxy' tab, select "Tor," and then either use the internal daemon, or point to your own with `127.0.0.1` (Host), `9050` (Port), and disable the Feather internal daemon. Click OK
1. That's it, you're ready to use Feather Wallet with your own Monero node!
