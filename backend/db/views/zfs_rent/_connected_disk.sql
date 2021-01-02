BEGIN;

  DROP VIEW IF NOT EXISTS _connected_disk;
CREATE VIEW _connected_disk AS (
  -- Determine the latest lsblk timestamp for each hostname
  WITH s1 AS (
    SELECT
      hostname,
      max(unix_time) as unix_time
    FROM metrics
    WHERE cmd = 'lsblk --output-all --json'
    GROUP BY hostname
  ),

  -- Unnest json array of lsblk devices
  s2 AS (
    SELECT
      to_timestamp(unix_time) as ts,
      hostname,
      jsonb_array_elements(jsn->'blockdevices') as dev
    FROM metrics
    WHERE unix_time IN (SELECT unix_time FROM s1)
  )

  -- Pull out name, model, and serial
  SELECT
    ts, hostname,
    dev->>'name'   as name,
    dev->>'model'  as model,
    dev->>'serial' as serial
  FROM s2
  WHERE dev->>'rota' = '1' -- rotational disks only
);

COMMIT;
