import { Backups } from "../dependencies.ts";

export const { createBackup, restoreBackup } = Backups.with_options({ exclude: ['lmdb', 'cert'] }).volumes("main").build();
