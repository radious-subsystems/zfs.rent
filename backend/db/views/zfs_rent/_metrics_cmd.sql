CREATE VIEW _metrics_cmd AS (
  -- search past metrics and find max(ts) for each host+command
  WITH s1 AS (
    SELECT
      cmd AS command,
      hostname,
      max(ts) AS max_ts
    FROM metrics
    WHERE ts >= (CURRENT_TIMESTAMP - INTERVAL '1 day')
    GROUP BY 1, 2
  ),

  -- join metrics_cmds onto history
  s2 AS (
    SELECT
      command,
      output_type,
      frequency,
      hostname,
      COALESCE(
        EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP-max_ts)),
        7*86400 -- default to one week
      ) as dt
    FROM metrics_cmd
    LEFT JOIN s1 USING (command)
  )

  -- filter for commands that need to be run
  SELECT hostname, command, output_type, dt
  FROM s2
  WHERE (dt > frequency)
);
