import { types as T, matches, YAML } from "../deps.ts";
export { matches, T };
const { dictionary, boolean, shape, string, any } = matches;

type Check = {
  currentError(config: T.Config): string | void;
  fix(config: T.Config): void;
};

async function readConfig(effects: T.Effects): Promise<T.Config> {
  const configMatcher = dictionary([string, any]);
  const config = configMatcher.unsafeCast(
    await effects
      .readFile({
        path: "start9/config.yaml",
        volumeId: "main",
      })
      .then(YAML.parse)
  );
  return config;
}
