BEGIN;

DROP TABLE journal;

CREATE TABLE journal (
  id      TEXT PRIMARY KEY, -- _BOOT_ID + __REALTIME_TIMESTAMP
  ts      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  content JSONB
);

COMMIT;

-- Tue Dec  7 06:44:43 PM PST 2021
CREATE INDEX journal_pg_bad_connection_idx
  ON journal (ts)
  WHERE content->>'MESSAGE' LIKE '%PG::ConnectionBad%';

-- Tue Jan 11 05:01:36 AM PST 2022
CREATE INDEX journal_hostname_idx
  ON journal (ts, (content->>'_HOSTNAME'));
