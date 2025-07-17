import { matches, FileHelper } from '@start9labs/start-sdk'
const { object, string } = matches

const shape = object({
  name: string.optional().onMismatch(undefined),
})

export const configYaml = FileHelper.yaml(
  {
    volumeId: 'main',
    subpath: '/config.yml',
  },
  shape,
)
