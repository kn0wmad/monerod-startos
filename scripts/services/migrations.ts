import { compat, types as T } from "../dependencies.ts";

export const migration: T.ExpectedExports.migration = compat.migrations
    .fromMapping({}, "0.18.3.1" );
