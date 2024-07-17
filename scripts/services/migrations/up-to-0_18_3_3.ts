import { types as T, matches } from "../../deps.ts";
const { dictionary, boolean, shape, string, any } = matches;

export const migration_up_to_0_18_3_3 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          tor: matches.shape({ disablerpcban: matches.boolean }, [
            "disablerpcban",
          ]),
        }),
      })
      .test(config)
  ) {
    let rpcban = !config.advanced.tor.disablerpcban;
    delete config.advanced.tor.disablerpcban;
    config = {
      ...config,
      rpcban: rpcban,
    };
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          p2p: matches.shape({ disablegossip: matches.boolean }, [
            "disablegossip",
          ]),
        }),
      })
      .test(config)
  ) {
    let letneighborsgossip = !config.advanced.p2p.disablegossip;
    delete config.advanced.p2p.disablegossip;
    config = {
      ...config,
      letneighborsgossip: letneighborsgossip,
    };
  }

  return config;
};
