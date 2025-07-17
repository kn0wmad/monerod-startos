import { setupManifest } from '@start9labs/start-sdk'
import { SDKImageInputSpec } from '@start9labs/start-sdk/base/lib/types/ManifestTypes'

const BUILD = process.env.BUILD || ''

const architectures =
  BUILD === 'x86_64' || BUILD === 'aarch64' ? [BUILD] : ['x86_64', 'aarch64']

export const manifest = setupManifest({
  id: 'monerod',
  title: 'Monero',
  license: 'BSD-3',
  wrapperRepo: 'https://github.com/kn0wmad/monerod-startos',
  upstreamRepo: 'https://github.com/monero-project/monero',
  supportSite: 'https://github.com/monero-project/monero',
  marketingSite: 'https://getmonero.org',
  donationUrl: null,
  docsUrl:
    'https://github.com/kn0wmad/monerod-startos/blob/master/docs/instructions.md',
  description: {
    short: 'A Monero full node',
    long: ' Monero is a private, secure, untraceable, decentralized digital currency. You are your bank, you control your funds, and nobody can trace your transfers unless you allow them to do so. This is a headless (no GUI) server, used via an external Monero wallet.',
  },
  volumes: ['main'],
  images: {
    monerod: {
      source: { dockerTag: 'ghcr.io/sethforprivacy/simple-monerod:v0.18.4.2' },
      arch: architectures,
    } as SDKImageInputSpec,
    walletRpc: {
      source: {
        dockerTag: 'ghcr.io/sethforprivacy/simple-monero-wallet-rpc:v0.18.4.2',
        arch: architectures,
      },
    } as SDKImageInputSpec,
  },
  hardwareRequirements: {
    arch: architectures,
  },
  alerts: {
    install: null,
    update: null,
    uninstall: 'Uninstalling Monero will result in permanent loss of data. Without a backup, any funds stored on your node\'s default hot wallet will be lost forever. If you are unsure, we recommend making a backup, just to be safe.',
    restore:
      'Restoring Monero will overwrite its current data. You will lose any transactions recorded in watch-only wallets, and any funds you have received to the hot wallet since the last backup.',
    start: null,
    stop: null,
  },
  dependencies: {},
})
