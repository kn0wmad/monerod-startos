# Anonero Wallet (Mobile)

## Available For:

- Android

## Setup

| PLEASE NOTE: This guide assumes that you have setup [Tor](https://docs.start9.com/latest/user-manual/connecting/connecting-tor/tor-os/tor-android) connectivity on your Android device before continuing.

1. Download [Anonero](http://anonero5wmhraxqsvzq2ncgptq6gq45qoto6fnkfwughfl4gbt44swad.onion/) (onion link). There are two apps, Anon, and Nero.
1. Open Anon and create a wallet.
1. Copy your "Restricted RPC URL" connection string from StartOS -> Monero -> Properties.
1. Paste into the "Node" field, and modify the protocol prefix to `http://`. Leave the `:18089` port suffix as is. You can leave RPC user and password blank at this time.
1. If this does not connect right away, tap "Proxy Settings" and then "Set." Anon will connect to your node. Tap Next.
1. Create a passphrase. Save this, and the following seed phrase, somewhere safe. Don't fuck this up - freedom requires responsibility.
1. Continue to your wallet, and wait for it to sync to your node.

|Note: Nero set up is similar, but you will be restoring an existing wallet instead of creating one.
