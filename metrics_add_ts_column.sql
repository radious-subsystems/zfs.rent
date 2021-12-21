\timing on

/*
ALTER TABLE metrics
  ADD COLUMN IF NOT EXISTS
  ts TIMESTAMPTZ GENERATED ALWAYS AS (to_timestamp(unix_time)) STORED;

ALTER TABLE metrics
  ADD COLUMN IF NOT EXISTS
  ts TIMESTAMPTZ;

CREATE INDEX CONCURRENTLY
  metrics_unix_time_where_ts_null_btree_partial_idx
  ON metrics USING btree(unix_time)
  WHERE ts IS NULL;
*/

BEGIN;

CREATE TEMP TABLE tt AS
  SELECT
      (SELECT max(unix_time) FROM metrics WHERE ts IS NULL) - 3600 as min,
      (SELECT max(unix_time) FROM metrics WHERE ts IS NULL) as max;
\x
SELECT
  to_timestamp(min) as min_ts,
  to_timestamp(max) as max_ts
FROM tt;
\x

UPDATE metrics
  SET ts = to_timestamp(unix_time)
  WHERE
    ts IS NULL AND
    unix_time BETWEEN
    (SELECT min FROM tt)
    AND
    (SELECT max FROM tt);

COMMIT;
