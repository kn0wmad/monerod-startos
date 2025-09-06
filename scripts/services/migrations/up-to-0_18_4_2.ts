import { types as T, matches } from "../../deps.ts";
const { dictionary, boolean, shape, string, any } = matches;

export const migration_up_to_0_18_4_2 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }
  return config;
};
