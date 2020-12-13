-- software system log
CREATE TABLE IF NOT EXISTS sw_syslog (
  uuid UUID PRIMARY KEY DEFAULT public.gen_random_uuid(),
  ts   TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,

  -- See syslog.txt for valid levels
  level INTEGER DEFAULT 5,

  -- supporting metadata
  username TEXT,
  hostname TEXT,

  -- primary syslog contents
  module  TEXT NOT NULL, -- script/program that is running
  tag     TEXT NOT NULL, -- function name that is executing
  message TEXT NOT NULL, -- dynamic user content / error message
  context JSON           -- (optional) program-generated error/warning message
);
