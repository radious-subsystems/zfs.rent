BEGIN;

  DROP VIEW IF EXISTS _hddtemp;
CREATE VIEW _hddtemp AS (
  -- Create timeseries of drive_name->temp_c
  WITH s1 as (
    SELECT
      to_timestamp(unix_time) as ts,
      hostname,
      split_part(line, ':', 1) as name,
      regexp_replace(
        split_part(line, ':', 3),
        '[^0-9.]+', '', 'g'
      )::REAL as temp_c
    FROM
      metrics,
      unnest(string_to_array(txt, E'\n')) as x(line)
    WHERE
      cmd = 'hddtemp -w' AND
      line != ''
  )

  -- Join serial data onto table
  SELECT
    s1.ts,
    s1.hostname,
    cd.model,
    cd.serial,
    s1.temp_c
  FROM s1
  LEFT JOIN _connected_disk cd
    ON  s1.name = '/dev/' || cd.name
    AND s1.hostname = cd.hostname
);

COMMIT;
