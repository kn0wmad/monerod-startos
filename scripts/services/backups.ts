import { Backups } from "../deps.ts";

export const { createBackup, restoreBackup } = Backups.with_options({
  exclude: ["lmdb", "cert"],
})
  .volumes("main")
  .build();
