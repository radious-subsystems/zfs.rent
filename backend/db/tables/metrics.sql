CREATE TABLE metrics (
  -- when, what, where
  unix_time NUMERIC DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP),
  hostname  TEXT,
  cmd       TEXT,
  PRIMARY KEY (unix_time, hostname, cmd),

  -- several payload types
  jsn JSONB,
  txt TEXT,
  xml XML
);
