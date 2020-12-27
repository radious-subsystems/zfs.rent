DROP VIEW IF EXISTS _m1_sensors;
CREATE VIEW _m1_sensors AS (
  select
    to_timestamp(unix_time) as ts,
    hostname,
    content::json#>>'{nct6792-isa-0290,CPUTIN,temp2_input}' as cpu_temp_degrees_c,
    content::json#>>'{nct6792-isa-0290,fan2,fan2_input}' as cpu_fan_rpm
  from m1_sensors
  WHERE
    (hostname IS NULL OR hostname = 'm1.radious.co')
    AND content LIKE '{%}'
);
