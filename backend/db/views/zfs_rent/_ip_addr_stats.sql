-- sample the total byte count per interface (since boot)

BEGIN;

  DROP VIEW IF EXISTS _ip_addr_stats;
CREATE VIEW _ip_addr_stats AS (
  WITH s1 AS (
    SELECT
      to_timestamp(unix_time) as ts,
      jsonb_array_elements(jsn) as content
    FROM metrics
    WHERE
      cmd = 'ip -stats -json addr show'
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
    content->>'ifname' LIKE 'vnet%' OR
    content->>'ifname' LIKE 'macvtap%'
);

COMMIT;
