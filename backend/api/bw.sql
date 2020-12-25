-- parse json from `ip -stats link show`
with s1 as (
  select
    to_timestamp(unix_time) as ts,
    json_array_elements(content::json) as json
  from m1_sensors
  where
    hostname = 'h1.radious.co'
    and cmd like '%ip%show'
  order by unix_time desc
),

-- pull out gigabytes rx and tx per mac
s2 as (
  select
    ts,
    (json->>'address') as mac_addr,
    ((json#>>'{stats64,rx,bytes}')::BIGINT/1e9)::NUMERIC(9,2) as rx_gb,
    ((json#>>'{stats64,tx,bytes}')::BIGINT/1e9)::NUMERIC(9,2) as tx_gb
  from s1
),

-- compute daily max
s3 as (
  select
    ts::date as date,
    max(rx_gb) as rx_gb,
    max(tx_gb) as tx_gb
  from s2
  group by date
  order by date
)

-- calculate deltas (i.e. daily usage)
select
  date::text,
  (case
    when lag(rx_gb) over (order by date) is null then rx_gb
    else rx_gb - lag(rx_gb) over (order by date)
  end) as rx_gb,
  (case
    when lag(tx_gb) over (order by date) is null then tx_gb
    else tx_gb - lag(tx_gb) over (order by date)
  end) as tx_gb
from s3;
