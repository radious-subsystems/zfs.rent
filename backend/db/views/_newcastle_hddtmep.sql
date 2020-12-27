DROP VIEW IF EXISTS _newcastle_sensors;

CREATE VIEW _newcastle_sensors AS (
  WITH s1 AS (
    SELECT
      to_timestamp(round(unix_time)) as ts,
      AVG((content::json#>>'{coretemp-isa-0000,Package id 0,temp1_input}')::REAL) as cpu_pkg_temp_c
    FROM m1_sensors
    WHERE
      hostname = 'newcastle.radious.co'
      AND content LIKE '{%}'
    GROUP BY ts
  ),
  
  s2 AS (
    SELECT
      to_timestamp(round(unix_time)) as ts,
      regexp_split_to_table(content, '\n') as hddtemp
    FROM hddtemp
    WHERE
      hostname = 'newcastle.radious.co'
      AND content LIKE '/dev/sd%'
  ),

  s3 AS (
    SELECT
      ts,
      substring(hddtemp, '^(/dev/...):') as hard_drive,
      substring(hddtemp, '^/dev/...: .*: (.*).C$')::REAL as hard_drive_temp_c
    FROM s2
  ),

  sda_cte AS (SELECT ts, hard_drive_temp_c as sda_temp_c FROM s3 WHERE hard_drive = '/dev/sda')

  SELECT
    ts,
    cpu_pkg_temp_c,
    sda_temp_c
  FROM s1
    FULL OUTER JOIN sda_cte USING (ts)
  ORDER BY ts DESC
);

SELECT * FROM _newcastle_sensors LIMIT 50;
