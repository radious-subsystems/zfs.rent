CREATE VIEW _mir_speedtest AS (
  SELECT
    date_trunc('hour', to_timestamp(unix_time)) as ts,
    (avg((content->>'download')::REAL)/1e6)::INT as dl_mbps,
    (avg((content->>'upload'  )::REAL)/1e6)::INT as ul_mbps
  FROM mir_speedtest
  WHERE hostname = 'rmj.us'
  GROUP BY 1
)
