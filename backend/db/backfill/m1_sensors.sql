BEGIN;

insert into metrics (unix_time, hostname, cmd, jsn)
  select unix_time, hostname, cmd, content::jsonb as jsn
  from m1_sensors
  where cmd LIKE '%-j%';

drop table hddtemp_script, m1_sensors;

commit;
