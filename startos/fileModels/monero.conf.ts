import { FileHelper, matches } from '@start9labs/start-sdk'
import { moneroConfDefaults } from '../utils'

const { object, literal, string, number } = matches

const {
  dataDir,
  logLevel,
  logFile,
  maxLogFileSize,
  maxLogFiles,
  p2pBindIp,
  p2pBindPort,
  rpcBindIp,
  rpcBindPort,
  confirmExternalBind,
  rpcAccessControlOrigins,
  rpcRestrictedBindIp,
  rpcRestrictedBindPort,
  dbSyncMode,
  enforceDnsCheckpointing,
  disableDnsCheckpoints,
  checkUpdates,
} = moneroConfDefaults

export const shape = object({
  // Data & logging
  'data-dir': string.onMismatch(dataDir),
  'log-level': string.onMismatch(logLevel),
  'log-file': literal(logFile),
  'max-log-file-size': number.onMismatch(maxLogFileSize),
  'max-log-files': number.onMismatch(maxLogFiles),

  // P2P
  'p2p-bind-ip': literal(p2pBindIp).onMismatch(p2pBindIp),
  'p2p-bind-port': literal(p2pBindPort).onMismatch(p2pBindPort),

  // RPC (unrestricted)
  'rpc-bind-ip': literal(rpcBindIp).onMismatch(rpcBindIp),
  'rpc-bind-port': literal(rpcBindPort).onMismatch(rpcBindPort),
  'confirm-external-bind': number.onMismatch(confirmExternalBind),
  'rpc-access-control-origins': string.onMismatch(rpcAccessControlOrigins),

  // RPC (restricted)
  'rpc-restricted-bind-ip': literal(rpcRestrictedBindIp).onMismatch(rpcRestrictedBindIp),
  'rpc-restricted-bind-port': literal(rpcRestrictedBindPort).onMismatch(rpcRestrictedBindPort),

  // DB & mempool
  'db-sync-mode': string.onMismatch(dbSyncMode),

  // DNS & updates
  'enforce-dns-checkpointing': number.onMismatch(enforceDnsCheckpointing),
  'disable-dns-checkpoints': number.onMismatch(disableDnsCheckpoints),
  'check-updates': string.onMismatch(checkUpdates),
})

function onWrite(a: unknown): any {
  if (a && typeof a === 'object') {
    if (Array.isArray(a)) {
      return a.map(onWrite)
    }
    return Object.fromEntries(
      Object.entries(a).map(([k, v]) => [k, onWrite(v)]),
    )
  } else if (typeof a === 'boolean') {
    return a ? 1 : 0
  }
  return a
}

export const bitcoinConfFile = FileHelper.ini(
  {
    volumeId: 'main',
    subpath: '/monero.conf',
  },
  shape,
  { bracketedArray: false },
  {
    onRead: (a) => a,
    onWrite,
  },
)
