CREATE TABLE vercel_api_log (
  ts      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  req     JSONB,
  context JSONB
);
