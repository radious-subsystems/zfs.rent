BEGIN;

  DROP VIEW _ip_link_stats;
CREATE VIEW _ip_link_stats AS (
  WITH s1 AS (
    SELECT
      to_timestamp(unix_time) as ts,
      json_array_elements(content::JSON) as content
    FROM m1_sensors
    WHERE
      cmd = 'ip -stats -json link show'
  )

  SELECT
    ts,
    --content->>'ifindex'   as index,
    --content->'flags'      as flags,
    --content->>'link_type' as type,
    content->>'address' as addr,
    content->>'ifname'  as name,
    ((content#>>'{stats64,rx,bytes}')::REAL/1e9)::NUMERIC(9,2) as rx_gb,
    ((content#>>'{stats64,tx,bytes}')::REAL/1e9)::NUMERIC(9,2) as tx_gb
  FROM s1
  WHERE
    content->>'ifname' LIKE 'vnet%'
);

COMMIT;
