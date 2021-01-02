CREATE TABLE metrics (
  -- when, what, where
  unix_time NUMERIC DEFAULT EXTRACT(EPOCH FROM CURRENT_TIMESTAMP),
  hostname  TEXT,
  cmd       TEXT,
  PRIMARY KEY (unix_time, hostname, cmd),

  -- process return status + stderr
  status TEXT,
  stderr TEXT,

  -- several payload types
  jsn JSONB,
  txt TEXT,
  xml XML
);
