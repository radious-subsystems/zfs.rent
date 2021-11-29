CREATE TABLE journal (
  ts      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  host    TEXT,
  cursor  TEXT,
  content JSONB,
  PRIMARY KEY (host, cursor)
);
