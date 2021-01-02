ROLLBACK;
BEGIN;

DROP VIEW IF EXISTS _user_bandwidth;

CREATE VIEW _user_bandwidth AS (
  WITH s1 as (
    SELECT
      ts::date as date, addr,
      max(rx_gb + tx_gb) as gb_consumed
    FROM _ip_link_stats
    GROUP BY 1, 2
    ORDER BY 1 ASC
  )

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
  ORDER BY domain ASC, date ASC
);

SELECT * FROM _user_bandwidth;

COMMIT;
