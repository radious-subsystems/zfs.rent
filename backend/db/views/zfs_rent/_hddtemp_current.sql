BEGIN;

  DROP VIEW IF EXISTS _hddtemp_current;
CREATE VIEW _hddtemp_current AS (
  -- Grab the latest hddtemp samples per hostname
  WITH s0 as (
    SELECT
      hostname,
      max(unix_time) as unix_time
    FROM metrics
    WHERE
      cmd = 'hddtemp -w'
    GROUP BY hostname
  ),

  -- unnest hddtemp text data
  s1 as (
    SELECT
      unix_time,
      hostname,
      unnest(string_to_array(txt, E'\n')) as line
    FROM metrics
    WHERE
      cmd = 'hddtemp -w' AND
      unix_time IN (SELECT unix_time FROM s0)
  ),

  -- Create timeseries of drive_name->temp_c
  s2 as (
    SELECT
      to_timestamp(unix_time) as ts,
      hostname,
      split_part(line, ':', 1) as name,
      regexp_replace(
        split_part(line, ':', 3),
        '[^0-9.]+', '', 'g'
      )::REAL as temp_c
    FROM s1
    WHERE
      unix_time IN (SELECT unix_time FROM s0) AND
      line != ''
  )

  -- Join serial data onto table
  SELECT
    s2.ts,
    s2.hostname,
    s2.name,
    cd.model,
    cd.serial,
    s2.temp_c
  FROM s2
  LEFT JOIN _connected_disk cd
    ON  s2.name = '/dev/' || cd.name
    AND s2.hostname = cd.hostname
);

COMMIT;
