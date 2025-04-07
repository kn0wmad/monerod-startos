import { types as T, matches } from "../../deps.ts";
const { dictionary, boolean, shape, string, any } = matches;

export const migration_up_to_0_18_4_0 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          p2p: matches.shape({ spynodebanlist: matches.boolean }, [
            "spynodebanlist",
          ]),
        }),
      })
      .test(config)
  ) {
    config = {
      ...config,
      .advanced.p2p.spynodebanlist = true,
    };
  }

  return config;
};
