CREATE TABLE netlify_functions_log (
  ts      TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
  event   JSONB,
  context JSONB
);
