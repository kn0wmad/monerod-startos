export const migration_down_from_0_18_4_0 = (config: T.Config): T.Config => {
  if (Object.keys(config).length === 0) {
    // service was never configured
    return config;
  }
  // the service was configured
  delete config.advanced.p2p.spynodebanlist;
  return config;
};
