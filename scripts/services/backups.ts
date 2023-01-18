import { Backups } from "../dependencies.ts";

export const { createBackup, restoreBackup } = Backups.volumes("main").build();
