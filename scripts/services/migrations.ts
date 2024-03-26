import { types as T, compat } from "../deps.ts";
import { migration_up_to_0_18_3_2 } from "./migrations/up-to-0_18_3_2.ts";

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
      "0.18.3.2": {
        up: compat.migrations.updateConfig(
          (config) => {
            return migration_up_to_0_18_3_2(config);
          },
          false,
          { version: "0.18.3.2", type: "up" }
        ),
        down: () => {
          throw new Error("Downgrade not possible");
        },
      },
    },
    "0.18.3.2"
  )(effects, version, ...args);
};
