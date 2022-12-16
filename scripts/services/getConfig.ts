import { compat, types as T } from "../dependencies.ts";

export const getConfig: T.ExpectedExports.getConfig = compat.getConfig({
    "peer-tor-address": {
      "name": "Peer Tor Address",
      "description": "The Tor address of the peer interface",
      "type": "pointer",
      "subtype": "package",
      "package-id": "monerod",
      "target": "tor-address",
      "interface": "peer"
    },
    "rpc-tor-address": {
      "name": "RPC Tor Address",
      "description": "The Tor address of the RPC interface",
      "type": "pointer",
      "subtype": "package",
      "package-id": "monerod",
      "target": "tor-address",
      "interface": "rpc"
    },
    "rpc": {
      "type": "object",
      "name": "RPC Settings",
      "description": "RPC configuration options.",
      "spec": {
        "enable": {
          "type": "boolean",
          "name": "Enable",
          "description": "Allow remote RPC requests.",
          "default": true
        },
        "username": {
          "type": "string",
          "nullable": false,
          "name": "Username",
          "description": "The username for connecting to Monero over RPC.",
          "default": "monero",
          "masked": false,
          "pattern": "^[a-zA-Z0-9_]+$",
          "pattern-description": "Must be alphanumeric (can contain underscore)."
        },
        "password": {
          "type": "string",
          "nullable": false,
          "name": "RPC Password",
          "description": "The password for connecting to Monero over RPC.",
          "default": {
            "charset": "a-z,2-7",
            "len": 32
          },
          "pattern": "^[^\\n\"]*$",
          "pattern-description": "Must not contain newline or quote characters.",
          "copyable": true,
          "masked": true
        }
      }
    }
  }
)