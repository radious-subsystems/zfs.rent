SELECT
  to_timestamp(unix_time) as ts,
  hostname,
  txt
FROM metrics
WHERE cmd = 'hddtemp -w';
