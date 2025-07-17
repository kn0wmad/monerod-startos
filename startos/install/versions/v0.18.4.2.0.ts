import { VersionInfo, IMPOSSIBLE } from '@start9labs/start-sdk'
import { sdk } from '../../sdk'
import { setName } from '../../actions/setName'
import { rm } from 'fs/promises'

export const v_0_18_4_2_0 = VersionInfo.of({
  version: '0.18.4.2:0-alpha.0',
  releaseNotes: 'Revamped for StartOS 0.4.0',
  migrations: {
    up: async ({ effects }) => {
      await sdk.action.createOwnTask(effects, setName, 'critical', {
        reason: 'How else will people know your name?',
      })

      // delete old start9 dir from 0.3.5.1
      rm('/media/startos/volumes/main/start9', { recursive: true }).catch(
        console.error,
      )
    },
    down: IMPOSSIBLE,
  },
})
