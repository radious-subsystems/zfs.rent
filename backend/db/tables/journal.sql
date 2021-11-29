CREATE TABLE journal (
  ts       TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  hostname TEXT,
  cursor   TEXT,
  content  JSONB,
  PRIMARY  KEY (hostname, cursor)
);
