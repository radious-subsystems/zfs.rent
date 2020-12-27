DROP VIEW IF EXISTS _m2_sensors;

CREATE VIEW _m2_sensors AS (
  WITH s1 AS (
    SELECT
      to_timestamp(round(unix_time)) as ts,
      AVG((content::json#>>'{k10temp-pci-00c3,Tdie,temp1_input}')::REAL) as cpu_temp_c
    FROM m1_sensors
    WHERE
      hostname = 'm2.radious.co'
      AND content LIKE '{%}'
    GROUP BY ts
  ),
  
  s2 AS (
    SELECT
      to_timestamp(round(unix_time)) as ts,
      regexp_split_to_table(content, '\n') as hddtemp
    FROM hddtemp
    WHERE
      hostname = 'm2.radious.co'
      AND content LIKE '/dev/sd%'
  ),

  s3 AS (
    SELECT
      ts,
      substring(hddtemp, '^(/dev/...):') as hard_drive,
      substring(hddtemp, '^/dev/...: .*: (.*).C$')::REAL as hard_drive_temp_c
    FROM s2
  ),

  sda_cte AS (SELECT ts, hard_drive_temp_c as sda_temp_c FROM s3 WHERE hard_drive = '/dev/sda'),
  sdb_cte AS (SELECT ts, hard_drive_temp_c as sdb_temp_c FROM s3 WHERE hard_drive = '/dev/sdb')

  SELECT
    ts,
    cpu_temp_c,
    (sda_temp_c + sdb_temp_c)/2 as avg_drive_temp_c,
    sda_temp_c,
    sdb_temp_c
  FROM s1
    FULL OUTER JOIN sda_cte USING (ts)
    FULL OUTER JOIN sdb_cte USING (ts)
  ORDER BY ts DESC
);

SELECT * FROM _m2_sensors LIMIT 50;
