BEGIN;

CREATE VIEW _user_bandwidth_balance AS (
  SELECT
    domain,
    period,
    gb_consumed,
    (1000.0 - gb_consumed)::NUMERIC(9,2) as gb_base_left,
    -- todo: tabulate addl bandwidth purchases using a view
    0 as gb_addl_left
  FROM __user_bandwidth_by_month
  WHERE
    period = to_char(CURRENT_TIMESTAMP, 'YYYY-MM')
);

select * from _user_bandwidth_balance;

commit; 
