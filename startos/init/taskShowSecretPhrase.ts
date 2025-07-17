import { showSecretPhrase } from '../actions/showSecretPhrase'
import { sdk } from '../sdk'

export const taskShowSecretPhrase = sdk.setupOnInit(async (effects, kind) => {
  if (kind === 'install') {
    await sdk.action.createOwnTask(effects, showSecretPhrase, 'important', {
      reason: 'Check out your secret phrase!',
    })
  }
})
