import { types as T, compat } from "../deps.ts";
import { migration_up_to_0_18_3_1 } from "./migrations/up-to-0_18_3_1.ts";
import { migration_down_to_0_18_2_2 } from "./migrations/down-to-0_18_2_2.ts";

export const migration: T.ExpectedExports.migration = async (
  effects,
  version,
  ...args
) => {
  await effects.createDir({
    path: "start9",
    volumeId: "main",
  });
  return compat.migrations.fromMapping(
    {
      //
      "0.18.3.1": {
        up: compat.migrations.updateConfig(
          (config) => {
            return migration_up_to_0_18_3_1(config);
          },
          false,
          { version: "0.18.3.1", type: "up" }
        ),
        down: compat.migrations.updateConfig(
          (config) => {
            return migration_down_to_0_18_2_2(config);
          },
          true,
          { version: "0.18.3.1", type: "down" }
        ),
      },
    },
    "0.18.3.1"
  )(effects, version, ...args);
};
