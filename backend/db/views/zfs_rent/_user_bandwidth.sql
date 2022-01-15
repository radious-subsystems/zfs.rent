DROP VIEW IF EXISTS _user_bandwidth CASCADE;

CREATE VIEW _user_bandwidth AS (
  -- For each address + date,
  -- extract the max xfer (rx + tb) stat from the address' interface
  WITH s1 as (
    SELECT
      ts::date as date, addr,
      max(rx_gb + tx_gb) as xfer_counter
    FROM _ip_link_stats
    GROUP BY date, addr
    ORDER BY date ASC
  ),

  -- Add lag xfer_counter column.
  -- (Prior day's xfer_counter. If not available --> assume 0 GB stat counter.)
  s2 AS (
    SELECT
      date, addr,
      xfer_counter,
      COALESCE(
        LAG(xfer_counter) OVER (PARTITION BY addr ORDER BY date),
        0
      ) as lag_xfer_counter
    FROM s1
  ),

  -- Calculate each day's delta gb_consumed.
  -- If a sample is missing --> assume that day's stat counter was 0 GB.
  s3 AS (
    SELECT
      date, addr,
      (CASE
        -- Calculate delta. If the counter reset --> use the current value.
        WHEN (xfer_counter < lag_xfer_counter) THEN xfer_counter
        ELSE (xfer_counter - lag_xfer_counter)
      END)::NUMERIC(9,2) as gb_consumed
    FROM s2
  )

  SELECT
    date, COALESCE(domain, 'NO_DOMAIN'),
    -- offset for misc. dc traffic
    --sum(GREATEST(0, gb_consumed - 10)) as gb_consumed
    -- sum() needed to collapse multiple entries for same domain,
    -- i.e. migrated VM to different hypervisor will cause multiple entries
    sum(gb_consumed) as gb_consumed
  FROM s3
  LEFT JOIN dhcp_src ON SUBSTRING(dhcp_src.mac, 10) = SUBSTRING(s3.addr, 10)
  GROUP BY date, domain
  ORDER BY domain ASC, date ASC
);
