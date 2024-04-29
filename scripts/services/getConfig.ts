import { compat, types as T } from "../deps.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  "peer-tor-address": {
    name: "Peer Address (Tor)",
    description:
      "The Tor address of the peer interface for incoming P2P connections",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "tor-address",
    interface: "peer",
  },
  "rpc-tor-address": {
    name: "RPC Interface Address (Tor)",
    description: "The Tor address of the unrestricted RPC interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "tor-address",
    interface: "rpc",
  },
  "rpc-lan-address": {
    name: "RPC Interface Address (LAN)",
    description: "The LAN address of the unrestricted RPC interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "lan-address",
    interface: "rpc",
  },
  "rpc-tor-address-restricted": {
    name: "RPC Interface Address (Restricted Calls) (Tor)",
    description:
      "The Tor address of the RPC interface that allows only a restricted set of API calls",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "tor-address",
    interface: "rpc-restricted",
  },
  "rpc-lan-address-restricted": {
    name: "RPC Interface Address (Restricted Calls) (LAN)",
    description:
      "The LAN address of the RPC interface that allows only a restricted set of API calls",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "lan-address",
    interface: "rpc-restricted",
  },
  "rpc-tor-address-wallet": {
    name: "Wallet RPC Interface Address (Tor)",
    description: "The Tor address of the wallet RPC interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "tor-address",
    interface: "rpc-wallet",
  },
  "rpc-lan-address-wallet": {
    name: "Wallet RPC Interface Address (LAN)",
    description: "The LAN address of the wallet RPC interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "lan-address",
    interface: "rpc-wallet",
  },
  "zmq-tor-address": {
    name: "ZMQ Interface Address (Tor)",
    description: "The Tor address of the ZMQ interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "tor-address",
    interface: "zmq",
  },
  "zmq-lan-address": {
    name: "ZMQ Interface Address (LAN)",
    description: "The LAN address of the ZMQ interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "lan-address",
    interface: "zmq",
  },
  "zmq-pubsub-tor-address": {
    name: "ZMQ Pub-Sub Interface Address (Tor)",
    description: "The Tor address of the ZMQ publish-subscribe interface",
    type: "pointer",
    subtype: "package",
    "package-id": "monerod",
    target: "tor-address",
    interface: "zmq-pubsub",
  },
  txpool: {
    type: "object",
    name: "Transaction Pool",
    description: "Unconfirmed transaction pool settings",
    spec: {
      maxbytes: {
        type: "number",
        nullable: false,
        name: "Maximum TX Pool Size",
        description:
          "Keep the unconfirmed transaction memory pool at or below this many megabytes.  You may wish to decrease this if you are low on RAM, or increase if you are mining. <br/><b>Default:</b> 648MiB.",
        range: "[1,*)",
        integral: true,
        units: "MiB",
        default: 648,
      },
    },
  },
  ratelimit: {
    type: "object",
    name: "Rate Limits",
    description:
      "Speed limits in kilobytes per second (kB/s).  You may wish to adjust if you have limited bandwidth or data from your Internet provider.",
    spec: {
      kbpsdown: {
        type: "number",
        nullable: false,
        name: "Download Speed Limit",
        description:
          "Keep the Monero p2p node's incoming bandwidth rate limited at or under this many kilobytes per second <br/><b>Default:</b> 8192 kB/s",
        range: "[1,*)",
        integral: true,
        units: "kB/s",
        default: 8192,
      },
      kbpsup: {
        type: "number",
        nullable: false,
        name: "Upload Speed Limit",
        description:
          "Keep the Monero p2p node's outgoing bandwidth rate limited at or under this many kilobytes per second <br/><b>Default:</b> 2048 kB/s",
        range: "[1,*)",
        integral: true,
        units: "kB/s",
        default: 2048,
      },
    },
  },
  rpc: {
    type: "object",
    name: "RPC Settings",
    description: "Remote Procedure Call configuration options",
    spec: {
      "rpc-credentials": {
        type: "union",
        name: "RPC Credentials",
        description: "Username and password for accessing the Monero RPC",
        tag: {
          id: "enabled",
          name: "RPC Credentials",
          description:
            "Enable or disable a username and password to access the Monero RPC <br/><b>Default:</b> Disabled",
          "variant-names": {
            disabled: "Disabled",
            enabled: "Enabled",
          },
        },
        default: "disabled",
        variants: {
          disabled: {},
          enabled: {
            username: {
              type: "string",
              nullable: false,
              name: "RPC Username",
              description:
                "The username for connecting to Monero's unrestricted RPC interface",
              warning:
                "Changing this value will necessitate a restart of all services that depend on Monero.",
              default: "monero",
              pattern: "^[a-zA-Z0-9_]+$",
              "pattern-description":
                "Must be alphanumeric and/or can contain an underscore",
            },
            password: {
              type: "string",
              nullable: false,
              name: "RPC Password",
              description:
                "The password for connecting to Monero's unrestricted RPC interface",
              warning:
                "Changing this value will necessitate a restart of all services that depend on Monero.",
              default: {
                charset: "a-z,A-Z,0-9,_",
                len: 22,
              },
              pattern: "^[a-zA-Z0-9_]+$",
              "pattern-description":
                "Must be alphanumeric (can contain underscore)",
              copyable: true,
              masked: true,
            },
          },
        },
      },
      "wallet-rpc-credentials": {
        type: "union",
        name: "Wallet RPC Credentials",
        description:
          "Username and password for accessing the Monero wallet RPC",
        tag: {
          id: "enabled",
          name: "Wallet RPC Credentials",
          description:
            "Enable or disable a username and password to access the Monero wallet RPC <br/><b>Default:</b> Disabled",
          "variant-names": {
            disabled: "Disabled",
            enabled: "Enabled",
          },
        },
        default: "disabled",
        variants: {
          disabled: {},
          enabled: {
            username: {
              type: "string",
              nullable: false,
              name: "Wallet RPC Username",
              description:
                "The username for connecting to Monero's wallet RPC interface",
              warning:
                "Changing this value will necessitate a restart of all services that depend on Monero's wallet RPC.",
              default: "monero_wallet",
              pattern: "^[a-zA-Z0-9_]+$",
              "pattern-description":
                "Must be alphanumeric and/or can contain an underscore",
            },
            password: {
              type: "string",
              nullable: false,
              name: "Wallet RPC Password",
              description:
                "The password for connecting to Monero's wallet RPC interface",
              warning:
                "Changing this value will necessitate a restart of all services that depend on Monero's wallet RPC.",
              default: {
                charset: "a-z,A-Z,0-9,_",
                len: 22,
              },
              pattern: "^[a-zA-Z0-9_]+$",
              "pattern-description":
                "Must be alphanumeric (can contain underscore)",
              copyable: true,
              masked: true,
            },
          },
        },
      },
    },
  },
  advanced: {
    type: "object",
    name: "Advanced",
    description: "Advanced Settings",
    spec: {
      p2p: {
        type: "object",
        name: "P2P",
        description: "Peer-to-Peer Connection Settings",
        spec: {
          maxnuminpeers: {
            type: "number",
            nullable: true,
            name: "Max Peers Incoming",
            description:
              "Maximum number of simultaneous peers connecting inbound to the Monero daemon <br/><b>Default:</b> 16 (Monero's default is unlimited but we prefer a ceiling to limit network surveillance from spy nodes and to discourage excessive bandwidth consumption)",
            range: "[0,9999]",
            integral: true,
            default: 16,
          },
          maxnumoutpeers: {
            type: "number",
            nullable: true,
            name: "Max Peers Outgoing",
            description:
              "Maximum number of simultaneous peers for the Monero daemon to connect outbound to <br/><b>Default:</b> 12",
            range: "[0,9999]",
            integral: true,
            default: 12,
          },
          letneighborsgossip: {
            type: "boolean",
            name: "Peer Gossip",
            description:
              "Disabling peer gossip will tell connected peers not to gossip our node info to their peers. This will make your node more private by stopping other nodes from learning how to make an inbound connection to it. Leaving this enabled will result in more connections for your node. <br/><b>Default:</b> Enabled",
            default: true,
          },
          publicrpc: {
            type: "boolean",
            name: "Advertise RPC Node",
            description:
              "Advertise our RPC port to P2P network peers.  Caution: this could significantly increase CPU, network, and RAM use, as well as disk (read) IO of the Monero daemon. <br/><b>Default:</b> Disabled",
            default: false,
          },
          /*
          "upnp": {
            "type": "boolean",
            "name": "Enable UPnP Port Mapping",
            "description":
              "Make automated requests to the local router to forward external ports from the router's public IP address to the Monero daemon's LAN address, facilitating inbound p2p connections from the clearnet internet to your Monero daemon behind a NAT.  This only works if your router supports UPnP and has it enabled.  This setting has no effect if you enable \"Tor Only\" mode.",
            "default": false,
          },
          */
          strictnodes: {
            type: "boolean",
            name: "Specific Nodes Only",
            description:
              "Only connect to the peers specified below and no other peers. <br/><b>Default:</b> Disabled",
            default: false,
          },
          peer: {
            name: "Add Peers",
            description:
              "Optionally add addresses of specific p2p nodes that your Monero node should connect to",
            type: "list",
            subtype: "object",
            range: "[0,*)",
            default: [],
            spec: {
              spec: {
                hostname: {
                  type: "string",
                  nullable: false,
                  name: "Hostname",
                  description:
                    "Domain name, onion or IP address of Monero peer.",
                  pattern:
                    "(^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$)|((^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$)|(^[a-z2-7]{16}\\.onion$)|(^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$))",
                  "pattern-description":
                    "Must be either a domain name, or an IPv4 or IPv6 address. Do not include protocol scheme (eg 'http://') or port.",
                },
                port: {
                  type: "number",
                  nullable: true,
                  name: "Port",
                  description:
                    "TCP Port that peer is listening on for inbound p2p connections.  <br/><b>Default:</b> 18080",
                  range: "[0,65535]",
                  integral: true,
                  default: 18080,
                },
                prioritynode: {
                  type: "boolean",
                  name: "Priority Node",
                  description:
                    "Attempt to stay perpetually connected to this peer",
                  default: false,
                },
              },
            },
          },
        },
      },
      tor: {
        type: "object",
        name: "Tor",
        description: "Tor anonymity network settings",
        spec: {
          toronly: {
            name: "Tor Only",
            description:
              "Only communicate with Monero nodes via Tor.  This is more private, but can be slower, especially during initial sync.  <br/><b>Default:</b> Enabled",
            type: "boolean",
            default: true,
          },
          rpcban: {
            type: "boolean",
            name: "Ban Misbehaving RPC Clients",
            description:
              "Ban hosts that generate RPC errors.  Leaving disabled may help to prevent monerod from banning traffic originating from the Tor daemon.  This is useful in Tor-only mode, where every connection inbound to the onion's RPC appears to be from same remote host.  <br/><b>Default:</b> Disabled",
            default: false,
          },
          maxonionconns: {
            type: "number",
            nullable: false,
            name: "Max Tor RPC Connections",
            description:
              "Maximum number of simultaneous connections allowed to be made to Monero's .onion RPC <b>Default:</b> 16",
            range: "[1,256]",
            integral: true,
            units: "Connections",
            default: 16,
          },
          maxsocksconns: {
            type: "number",
            nullable: false,
            name: "Max Tor Broadcast Connections",
            description:
              "Maximum number of simultaneous connections to Tor's SOCKS proxy when broadcasting transactions <br/><b>Default:</b> 16",
            range: "[1,256]",
            integral: true,
            units: "Connections",
            default: 16,
          },
          dandelion: {
            type: "boolean",
            name: "Dandelion++",
            description:
              'Enables white noise and Dandelion++ sender node obfuscation scheme.<br/>Enabled: It is harder to tell which node originated a transaction, but your peers could potentially silently censor your transactions by not propagating them.<br/>Disabled: Saves "white noise" bandwidth and may make broadcasting transactions more reliable.<br/>For more information, see https://www.getmonero.org/2020/04/18/dandelion-implemented.html <br/><b>Default:</b> Enabled',
            default: true,
          },
        },
      },
      zmq: {
        type: "boolean",
        name: "ZMQ Interface",
        description:
          "ZeroMQ is an asynchronous messaging library, aimed at use in distributed or concurrent applications. It provides a message queue without a dedicated message broker. <br/><b>Default:</b> Disabled",
        default: false,
      },
      pruning: {
        type: "boolean",
        name: "Pruning",
        description:
          "Blockchain pruning in Monero prunes proof data from transactions after verification but before storage.  This saves roughly 2/3s of disk space.  The drawback of pruning is that you will contribute less to the Monero P2P network in terms of helping new nodes doing IBD. If enabled, your node will still relay new transactions and blocks. <br/><b>Default:</b> Disabled",
        default: false,
      },
    },
  },
  integrations: {
    type: "object",
    name: "Integrations",
    description: "Settings for integrating Monero into other StartOS services",
    spec: {
      blocknotify: {
        type: "object",
        name: "Block Notify",
        description: "Notify other services of new Monero blocks",
        spec: {
          btcpayserver: {
            type: "boolean",
            name: "BTCPayServer",
            description:
              "Send notifications of new Monero blocks to the BTCPayServer backend. <br/><b>Default:</b> Disabled",
            default: false,
          },
        },
      },
    },
  },
});
