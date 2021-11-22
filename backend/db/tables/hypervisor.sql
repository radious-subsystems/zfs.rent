CREATE TABLE IF NOT EXISTS hypervisor (
  hostname   TEXT PRIMARY KEY,
  last_seen  TIMESTAMPTZ,
  uptime_cmd TEXT
);
