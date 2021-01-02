CREATE VIEW _user_disk_status AS (
  SELECT
    dhcp.ip,
    disk.domain,
    disk.model,
    disk.serial,
    h.ts as sampled_at,
    h.temp_c
  FROM disk
    JOIN _hddtemp_current h USING (serial)
    JOIN dhcp_src dhcp USING (domain)
);
