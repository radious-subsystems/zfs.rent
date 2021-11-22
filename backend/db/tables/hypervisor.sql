BEGIN;

CREATE TABLE IF NOT EXISTS hypervisor (
  hostname   TEXT PRIMARY KEY,
  last_seen  TIMESTAMPTZ,
  uptime_cmd TEXT
);

ALTER TABLE hypervisor ADD  COLUMN IF NOT EXISTS uptime_cmd_pretty TEXT;

ALTER TABLE hypervisor DROP COLUMN IF EXISTS uptime_cmd_pretty;
ALTER TABLE hypervisor ADD  COLUMN IF NOT EXISTS proc_uptime TEXT;

-- ROLLBACK;
COMMIT;
