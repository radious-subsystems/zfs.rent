drop view _h1_hddtemp;
create view _h1_hddtemp As (
  with s0 as (
    select
      unix_time,
      content
    from hddtemp
    where hostname = 'h1.radious.co'

    union

    select
      unix_time,
      content
    from m1_sensors
    where
      hostname = 'h1.radious.co' and
      cmd = 'hddtemp -w'
  ),

  s1 as (
    select
      to_timestamp(unix_time) as ts,
      replace(split_part(unnest(string_to_array(content, E'\n')), ': ', 3), '°C', '')::REAL as degrees_c
    from s0
    order by unix_time desc
  )

  select
    date_trunc('second', ts) as ts,
    avg(degrees_c)::numeric(9,2) as avg_degrees_c,
    min(degrees_c)::numeric(9,2) as min_degrees_c,
    max(degrees_c)::numeric(9,2) as max_degrees_c
  FROM s1
  group by ts
  order by ts desc
)
