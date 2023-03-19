import { compat, types as T } from "../dependencies.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
  "peer-tor-address": {
    "name": "Peer Tor Address",
    "description": "The Tor address of the peer interface",
    "type": "pointer",
    "subtype": "package",
    "package-id": "monerod",
    "target": "tor-address",
    "interface": "peer",
  },
  "rpc-tor-address": {
    "name": "RPC Tor Address",
    "description": "The Tor address of the RPC interface",
    "type": "pointer",
    "subtype": "package",
    "package-id": "monerod",
    "target": "tor-address",
    "interface": "rpc",
  },
  "txpool": {
    "type": "object",
    "name": "TX Pool",
    "description": "Unconfirmed Transaction Pool Settings",
    "spec": {
      "maxbytes": {
        "type": "number",
        "nullable": false,
        "name": "Maximum TX pool size",
        "description":
          "Keep the unconfirmed transaction memory pool at or below this many megabytes.",
        "range": "[1,*)",
        "integral": true,
        "units": "MiB",
        "default": 648,
      },
    }
  },
  "ratelimit": {
    "type": "object",
    "name": "Rate Limits",
    "description": "Speed limits in kilobytes per second (kB/s)",
    "spec": {
      "kbpsdown": {
        "type": "number",
        "nullable": false,
        "name": "Download Speed Limit",
        "description":
          "Keep the monero p2p node's incoming bandwidth rate limited at or under this many kilobytes per second.",
        "range": "[1,*)",
        "integral": true,
        "units": "kB/s",
        "default": 8192,
      },
      "kbpsup": {
        "type": "number",
        "nullable": false,
        "name": "Upload Speed Limit",
        "description":
          "Keep the monero p2p node's outgoing bandwidth rate limited at or under this many kilobytes per second",
        "range": "[1,*)",
        "integral": true,
        "units": "kB/s",
        "default": 2048,
      }
    }
  },
  "advanced": {
    "type": "object",
    "name": "Advanced",
    "description": "Advanced Settings",
    "spec": {
      "tor": {
        "type": "object",
        "name": "Tor",
        "description": "Tor anonymity network settings",
        "spec": {
          "toronly": {
            "name": "Tor only",
            "description":
              "Only communicate with Monero nodes via Tor",
            "type": "boolean",
            "default": true,
          },
          "disablerpcban": {
            "type": "boolean",
            "name": "Disable RPC ban",
            "description":
              "Do not ban hosts on RPC errors. May help to prevent monerod from banning traffic originating from the Tor daemon.  Useful in Tor-only mode, where every connection inbound to the onion's RPC appears to be from same remote host.",
            "default": true,
          },
          "maxonionconns": {
            "type": "number",
            "nullable": false,
            "name": "Max Tor RPC conns",
            "description":
              "Maximum number of simultaneous connections to Monero's .onion RPC",
            "range": "[1,256]",
            "integral": true,
            "units": "Connections",
            "default": 16,
          },
          "maxsocksconns": {
            "type": "number",
            "nullable": false,
            "name": "Max Tor broadcast conns",
            "description":
              "Maximum number of simultaneous connections to Tor's SOCKS proxy when broadcasting transactions",
            "range": "[1,256]",
            "integral": true,
            "units": "Connections",
            "default": 16,
          },
          "disabledandelion": {
            "type": "boolean",
            "name": "Disable Dandelion++",
            "description":
              "Disables white noise and Dandelion++ sender node obfuscation scheme.\nEnabled: It is harder to tell which node originated a transaction, but your peers could potentially silently censor your transactions by not propagating them.\nDisabled: Saves \"white noise\" bandwidth; may make broadcasting transactions more reliable.\nFor more information, see https://www.getmonero.org/2020/04/18/dandelion-implemented.html",
            "default": false,
          },
        },
      },
      "p2p": {
        "type": "object",
        "name": "P2P",
        "description": "Peer-to-Peer Connection Settings",
        "spec": {
          "maxnuminpeers": {
            "type": "number",
            "nullable": true,
            "name": "Max Peers Incoming",
            "description":
              "Maximum number of simultaneous peers connecting inbound to the Monero daemon",
            "range": "[0,999]",
            "integral": true,
            "default": 16,
          },
          "maxnumoutpeers": {
            "type": "number",
            "nullable": true,
            "name": "Max Peers Outgoing",
            "description":
              "Maximum number of simultaneous peers for the Monero daemon to connect outbound to",
            "range": "[0,8192]",
            "integral": true,
            "default": 64,
          },
          "disablegossip": {
            "type": "boolean",
            "name": "Disable Peer Gossip",
            "description": "Tell connected peers not to gossip our node info to their peers",
            "default": false,
          },
          "publicrpc": {
            "type": "boolean",
            "name": "Advertise RPC Node",
            "description":
              "Advertise to end-user wallets crawling the p2p network, and to other p2p network peers, that anyone can use this node's RPC interface (using a restricted, \"safe\" set of RPC calls) as a \"Remote Node\" for connecting their wallets.  Caution: this could significantly increase CPU, network, and RAM use, as well as disk (read) IO of the Monero daemon.",
            "default": false,
          },
          "upnp": {
            "type": "boolean",
            "name": "Enable UPnP Port Mapping",
            "description":
              "Make automated requests to the local router to forward external ports from the router's public IP address to the Monero daemon's LAN address, facilitating inbound p2p connections from the clearnet internet to your Monero daemon behind a NAT.  This only works if your router supports UPnP and has it enabled.  This setting has no effect if you enable \"Tor Only\" mode.",
            "default": false,
          },
          "strictnodes": {
            "type": "boolean",
            "name": "Specific Nodes Only",
            "description":
              "Only connect to the peers specified below and no other peers.",
            "default": false,
          },
          "peer": {
            "name": "Add Peers",
            "description": "Add addresses of p2p nodes that Monero should connect to.",
            "type": "list",
            "subtype": "object",
            "range": "[0,*)",
            "default": [],
            "spec": {
              "spec": {
                "hostname": {
                  "type": "string",
                  "nullable": false,
                  "name": "Hostname",
                  "description": "Domain name, onion or IP address of Monero peer",
                  "pattern":
                    "(^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$)|((^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))$)|(^[a-z2-7]{16}\\.onion$)|(^([a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$))",
                  "pattern-description":
                    "Must be either a domain name, or an IPv4 or IPv6 address. Do not include protocol scheme (eg 'http://') or port.",
                },
                "port": {
                  "type": "number",
                  "nullable": true,
                  "name": "Port",
                  "description":
                    "TCP Port that peer is listening on for inbound p2p connections",
                  "range": "[0,65535]",
                  "integral": true,
                  "default": 18080,
                },
                "prioritynode": {
                  "type": "boolean",
                  "name": "Priority Node",
                  "description":
                    "Attempt to stay perpetually connected to this peer.",
                  "default": false,
                },
              },
            },
          },
        },
      },
      "pruning": {
        "type": "union",
        "name": "Pruning Settings",
        "description":
          "Reduce the size of the blockchain stored on disk",
        "warning":
          "Pruning discards proof data from transactions after verification but before storage.  Enabling blockchain pruning saves 2/3 of disk space without degrading functionality. If you want to prune your blockchain, for maximum effect this should be enabled when you first sync because pruning only applies to blocks after you turn it on, not retroactively.<br/><br/>The drawback of pruning is that you will contribute less to Monero P2P network in terms of helping new nodes to sync up (down to 1/8 of normal contribution). Your node will still relay new transactions and blocks.",
        "tag": {
          "id": "mode",
          "name": "Prune Blocks",
          "description":
            "Blockchain pruning in Monero prunes proof data from transactions after verification but before storage.  This saves roughly 2/3s of disk space.",
          "variant-names": {
            "disabled": "Disabled",
            "prune": "Enable",
          },
        },
        "variants": {
          "disabled": {},
          "prune": {
            "syncprunedblocks": {
              "type": "boolean",
              "name": "Accept Pruned Blocks",
              "description":
                "Accept pre-pruned blocks from peers during intial sync, rather than receiving full blocks, verifying and then pruning them.  This is not recommended unless you are only pulling from your own trusted, fully-validating node using the \"Specific Nodes Only\" configuration section.",
              "warning":
                "Turning this on accepts pre-pruned blocks from peers during intial sync, rather than getting full blocks and our node pruning them.\n\nThis setting substantially reduces sync time and computational overhead, it also substantially changes the security assumptions by skipping full verification and trusting block hash checkpoints attested to and periodically manually inserted into the Monero code before release of new versions by the Monero core development team.  At best this has SPV-like security and at worst you are trusting a third party.",
              "default": false,
            },
          },
        },
        "default": "disabled",
      },
      
    },
  },
})
