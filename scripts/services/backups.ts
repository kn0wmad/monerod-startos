import { Backups } from "../dependencies.ts";

export const { createBackup, restoreBackup } = Backups.with_options({exclude: ['blocks','chainstate']}).volumes("main").build();