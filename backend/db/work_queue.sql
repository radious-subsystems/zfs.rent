CREATE TABLE work_queue (
  ts TIMESTAMPTZ PRIMARY KEY DEFAULT CURRENT_TIMESTAMP,

  -- for job queuer
  req_type TEXT NOT NULL,
  req_json JSON NOT NULL,

  -- for job workers
  locked_at TIMESTAMPTZ,
  done_at   TIMESTAMPTZ,

  -- generated column helpers
  is_done   BOOLEAN GENERATED ALWAYS AS (done_at IS NOT NULL),
  is_locked BOOLEAN GENERATED ALWAYS AS (locked_at IS NOT NULL)
);
