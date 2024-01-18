//import { I } from "../../deps.ts";
import { T, matches } from "../dependencies.ts";

const { shape, string, any, boolean } = matches;

const matchMoneroConfig = shape({
  monero: shape({
    advanced: shape({
      tor: shape({
        disablerpcban: boolean,
      }),

      p2p: shape({
        disablegossip: boolean,
      }),
    }),
  }),
});

const matchMoneroConfigForDeletion = shape({
  delete: shape({
    "advanced.tor.disablerpcban": any,
    "advanced.p2p.disablegossip": any,
  }),
});

//The migration to run for going from 0.18.2.2 to 0.18.3.1
export const migration_up_to_0_18_3_1 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }

  if (!matchMoneroConfig.test(config)) {
    throw `Could not find monerod key in config: ${matchMoneroConfig.errorMessage(
      config
    )}`;
  }
  type NewConfig = typeof matchMoneroConfig._TYPE & {
    monero: {
      advanced: {
        p2p: {
          disablegossip: never;
          letpeersgossip: boolean;
        };
        tor: {
          disablerpcban: never;
          rpcban: boolean;
        };
      };
    };
  };

  const newConfig = config as NewConfig;

  newConfig.monero.advanced.p2p.letpeersgossip =
    !config.monero.advanced.p2p.disablegossip;
  newConfig.monero.advanced.tor.rpcban =
    !config.monero.advanced.tor.disablerpcban;
  delete newConfig.monero.advanced.p2p.disablegossip;
  delete newConfig.monero.advanced.tor.disablerpcban;
  return newConfig;
};
