BEGIN;

DROP MATERIALIZED VIEW __user_bandwidth_by_month;
DROP VIEW _user_bandwidth_by_month;

CREATE VIEW _user_bandwidth_by_month AS (
  SELECT
    to_char(date, 'YYYY-MM') period,
    domain,
    SUM(gb_consumed) as gb_consumed
  FROM _user_bandwidth
  GROUP BY period, domain
);

CREATE MATERIALIZED VIEW __user_bandwidth_by_month AS (
  SELECT * FROM _user_bandwidth_by_month
);

COMMIT; 
