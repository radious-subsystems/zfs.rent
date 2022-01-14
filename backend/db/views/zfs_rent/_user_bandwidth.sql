DROP VIEW IF EXISTS _user_bandwidth CASCADE;

CREATE VIEW _user_bandwidth AS (
  WITH s1 as (
    SELECT
      ts::date as date, addr,
      max(rx_gb + tx_gb) as gb_consumed
    FROM _ip_link_stats
    GROUP BY 1, 2
    ORDER BY 1 ASC
  ),

  s2 AS (
    SELECT
      date, domain,
      gb_consumed -
      (CASE
        WHEN LAG(gb_consumed) OVER (PARTITION BY addr ORDER BY date) IS NULL
            THEN 0
        ELSE LAG(gb_consumed) OVER (PARTITION BY addr ORDER BY date)
      END)::NUMERIC(9,2) as gb_consumed
    FROM s1
    LEFT JOIN dhcp_src
      ON SUBSTRING(dhcp_src.mac, 10) = SUBSTRING(s1.addr, 10)
    WHERE domain IS NOT NULL
  )

  SELECT
    date,
    domain,
    -- offset for misc. dc traffic
    --sum(GREATEST(0, gb_consumed - 10)) as gb_consumed
    -- sum() needed to collapse multiple entries for same domain,
    -- i.e. migrated VM to different hypervisor will cause multiple entries
    sum(gb_consumed) as gb_consumed
  FROM s2
  GROUP BY date, domain
  ORDER BY domain ASC, date ASC
);
