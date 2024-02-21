import { matches, T } from "../dependencies.ts";

export const migration_down_to_0_18_2_2 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          p2p: matches.shape({ rpcban: matches.boolean }, ["rpcban"]),
        }),
      })
      .test(config)
  ) {
    let disablerpcban = !config.advanced.p2p.rpcban;
    delete config.advanced.p2p.rpcban;
    config = {
      ...config,
      disablerpcban: disablerpcban,
    }
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          p2p: matches.shape({ letneighborsgossip: matches.boolean }, ["letneighborsgossip"]),
        }),
      })
      .test(config)
  ) {
    let disablegossip = !config.advanced.p2p.letneighborsgossip;
    delete config.advanced.p2p.letneighborsgossip;
    config = {
      ...config,
      disablegossip: disablegossip,
    }
  }

  return config;

};
