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
          tor: matches.shape({ rpcban: matches.boolean }
          ),
        }),
      })
      .test(config)
  ) {
    let config.advanced.tor.disablerpcban:boolean = !config.advanced.tor.rpcban;
    delete config.advanced.tor.rpcban;
  } else {
    //Set a new value with a default to true
    let config.advanced.tor.disablerpcban:boolean = true;
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          p2p: matches.shape({ gossip: matches.boolean }
          ),
        }),
      })
      .test(config)
  ) {
    let config.advanced.p2p.disablegossip:boolean = !config.advanced.p2p.letpeersgossip;
    delete config.advanced.tor.letpeersgossip;
  } else {
    //Set a new value with a default to false
    let config.advanced.p2p.disablegossip:boolean = false;
  }

  return config;

};
