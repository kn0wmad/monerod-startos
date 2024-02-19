import { matches, T } from "../dependencies.ts";

export const migration_up_to_0_18_3_1 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          tor: matches.shape({ disablerpcban: matches.boolean }
          ),
        }),
      })
      .test(config)
  ) {
    let config.advanced.tor.rpcban:boolean = !config.advanced.tor.disablerpcban;
    delete config.advanced.tor.disablerpcban;
  } else {
    //Set a new value with a default to false
    let config.advanced.tor.rpcban:boolean = false;
  }

  if (
    matches
      .shape({
        advanced: matches.shape({
          p2p: matches.shape({ disablegossip: matches.boolean }
          ),
        }),
      })
      .test(config)
  ) {
    let config.advanced.p2p.letpeersgossip:boolean = !config.advanced.p2p.disablegossip;
    delete config.advanced.tor.disablegossip;
  } else {
    //Set a new value with a default to true
    let config.advanced.p2p.letpeersgossip:boolean = true;
  }

  return config;

};
