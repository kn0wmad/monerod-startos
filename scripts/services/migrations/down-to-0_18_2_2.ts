import { T, matches } from "../dependencies.ts";

const { shape, string, any, boolean } = matches;

const matchMoneroConfig = shape({
  monero: shape({
    "advanced.tor.rpcban": shape({
      type: boolean,
    }),
    "advanced.p2p.letpeersgossip": shape({
      type: boolean,
    }),
  }),
});

const matchMoneroConfigForDeletion = shape({
  delete: shape({
    "advanced.tor.rpcban": any,
    "advanced.p2p.letpeersgossip": any,
  }),
});

//The migration to run for going from 0.18.3.1 to 0.18.2.2
export const migration_down_to_0_18_2_2 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }

  if (!matchMoneroConfig.test(config)) {
    throw `Could not find monerod key in config: ${matchMoneroConfig.errorMessage(
      config
    )}`;
  }

  // rpcban is changing back to disablerpcban (and flipping any existing bool)
  if (config.monero["advanced.tor.rpcban"].type === "true") {
    config.monero["advanced.tor.disablerpcban"].type = "false";
  } else {
    config.monero["advanced.tor.disablerpcban"].type = "true";
  }

  // letpeersgossip is changing back to disablegossip (and flipping any existing bool)
  if (config.monero["advanced.p2p.letpeersgossip"].type === "true") {
    config.monero["advanced.p2p.disablegossip"].type = "false";
  } else {
    config.monero["advanced.p2p.disablegossip"].type = "true";
  }

  // If the premigration keys/values exist, delete them:
  if (matchMoneroConfigForDeletion.test(config)) {
    delete config.delete["advanced.tor.rpcban"];
    delete config.delete["advanced.p2p.letpeersgossip"];
  }

  return config;
};
