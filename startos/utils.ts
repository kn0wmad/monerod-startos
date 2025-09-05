export const BITMONERO_DIR = '/data/.bitmonero'
export const MONERO_LOGS_DIR = `${BITMONERO_DIR}/logs`
export const MONERO_WALLET_DIR = `${BITMONERO_DIR}/wallets`
export const MONERO_LOG = `${MONERO_LOGS_DIR}/monerod.log`
export const MONERO_WALLET_RPC_LOG = `${MONERO_LOGS_DIR}/monero-wallet-rpc.log`

export const MONERO_LAN_HOSTNAME = 'monerod.startos'
export const MONEROD_LOCAL_HOST = '127.0.0.1'
export const MONEROD_BIND_IP = '0.0.0.0'

export const MONERO_P2P_PORT = 18080
export const MONERO_RPC_PORT = 18081
export const MONERO_ZMQ_PORT = 18082
export const MONERO_ZMQ_PUBSUB_PORT = 18083
export const MONERO_P2P_PORT_LOCAL_BIND = 18084
export const MONERO_RPC_PORT_RESTRICTED = 18089
export const MONERO_RPC_PORT_WALLET_RPC = 28088

export const moneroConfDefaults = {
  // Data & logging
  dataDir: BITMONERO_DIR,
  logLevel: '0,blockchain:INFO',
  logFile: MONERO_LOG,
  maxLogFileSize: 10_000_000,
  maxLogFiles: 2,

  // P2P
  p2pBindIp: MONEROD_BIND_IP,
  p2pBindPort: MONERO_P2P_PORT,

  // RPC (unrestricted)
  rpcBindIp: MONEROD_LOCAL_HOST,
  rpcBindPort: MONERO_RPC_PORT,
  confirmExternalBind: 1,
  rpcAccessControlOrigins: '*',

  // RPC (restricted)
  rpcRestrictedBindIp: MONEROD_BIND_IP,
  rpcRestrictedBindPort: MONERO_RPC_PORT_RESTRICTED,

  // DB & mempool
  dbSyncMode: 'safe:sync',

  // DNS & updates
  enforceDnsCheckpointing: 0,
  disableDnsCheckpoints: 1,
  checkUpdates: 'disabled',
} as const