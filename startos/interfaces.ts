import { sdk } from './sdk'
import { ports } from './utils'

const { peer: peerPort, rpcRestricted: rpcPort, zmq: zmqPort } = ports

export const setInterfaces = sdk.setupInterfaces(async ({ effects }) => {
  let config = await moneroConfFile.read().const(effects)

  if (!config) return []

  // RPC
  const rpcMulti = sdk.MultiHost.of(effects, 'rpc')
  const rpcMultiOrigin = await rpcMulti.bindPort(rpcPort, {
    protocol: 'http',
    preferredExternalPort: rpcPort,
  })
  const rpc = sdk.createInterface(effects, {
    name: 'RPC Interfce',
    id: 'rpc',
    description: 'Listens for JSON-RPC commands',
    type: 'api',
    masked: false,
    schemeOverride: null,
    username: null,
    path: '',
    query: {},
  })
  const rpcReceipt = await rpcMultiOrigin.export([rpc])
  const receipts = [rpcReceipt]

  // PEER
  const peerMulti = sdk.MultiHost.of(effects, 'peer')
  const peerMultiOrigin = await peerMulti.bindPort(peerPort, {
    protocol: null,
    preferredExternalPort: peerPort,
    addSsl: null,
    secure: { ssl: false },
  })
  const peer = sdk.createInterface(effects, {
    name: 'Peer Interface',
    id: 'peer',
    description:
      'Listens for incoming connections from peers on the monero network',
    type: 'p2p',
    masked: false,
    schemeOverride: { ssl: null, noSsl: null },
    username: null,
    path: '',
    query: {},
  })
  const peerReceipt = await peerMultiOrigin.export([peer])
  receipts.push(peerReceipt)

  // ZMQ (conditional)
  if (config.zmq) {
    const zmqMulti = sdk.MultiHost.of(effects, 'zmq')
    const zmqMultiOrigin = await zmqMulti.bindPort(zmqPort, {
      preferredExternalPort: zmqPort,
      addSsl: null,
      secure: { ssl: false },
      protocol: null,
    })
    const zmq = sdk.createInterface(effects, {
      name: 'ZeroMQ Interface',
      id: 'zmq',
      description:
        'ZeroMQ is an asynchronous messaging library, aimed at use in distributed or concurrent applications. It provides a message queue without a dedicated message broker.',
      type: 'api',
      masked: false,
      schemeOverride: null,
      username: null,
      path: '',
      query: {},
    })
    const zmqReceipt = await zmqMultiOrigin.export([zmq])
    receipts.push(zmqReceipt)
  }

  return receipts
})
