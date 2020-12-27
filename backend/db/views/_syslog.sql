CREATE OR REPLACE VIEW _syslog AS (
  SELECT
    to_timestamp(unix_time) as ts,
    (CASE
      WHEN level=0 THEN 'FATAL'
      WHEN level=1 THEN 'ERROR'
      WHEN level=2 THEN 'WARNING'
      WHEN level=3 THEN 'INFO'
      WHEN level=4 THEN 'VERBOSE'
      WHEN level=5 THEN 'DEBUG'
      ELSE 'UNKNOWN'
    END) as level,
    hostname,
    module, tag, content
  FROM syslog_
  ORDER BY 1 ASC
);

GRANT SELECT ON _syslog TO radious_ro;
