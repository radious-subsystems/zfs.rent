ROLLBACK;
BEGIN;

DROP VIEW IF EXISTS _user_bandwidth;

CREATE VIEW _user_bandwidth AS (
  SELECT
    ts::date, addr,
    max(rx_gb) as rx_gb,
    max(tx_gb) as tx_gb
  FROM _ip_link_stats
  JOIN 
  GROUP BY 1, 2
  ORDER BY 1, 2 DESC
);

SELECT * FROM _ip_link_deriv;

COMMIT;
