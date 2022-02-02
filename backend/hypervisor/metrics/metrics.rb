#!/usr/bin/env ruby

require "pg"
require "open3"
require_relative "./journal"

pg = PG.connect()

def hostname
  `uname -n`.strip
end

# report last_seen
puts pg.exec(%{
  INSERT INTO hypervisor
  (hostname, last_seen, uptime_cmd, proc_uptime)
  VALUES ($1, CURRENT_TIMESTAMP, $2, $3)
  ON CONFLICT (hostname) DO UPDATE SET
    last_seen   = EXCLUDED.last_seen,
    uptime_cmd  = EXCLUDED.uptime_cmd,
    proc_uptime = EXCLUDED.proc_uptime;
}, [hostname, `uptime`, `cat /proc/uptime`]).to_a

# log journal
log_journal(pg, line_count: 100)

# https://bibwild.wordpress.com/2013/03/12/removing-illegal-bytes-for-encoding-in-ruby-1-9-strings/
def clean(str)
  return str.encode(
    "UTF-8",
    :invalid => :replace, :undef => :replace)
end

# post metrics
rows = pg.exec("SELECT * FROM _metrics_cmd WHERE hostname = $1;", [hostname]).to_a
rows.each do |row|
  # fork and execute command --> insert to postgres
  pid = fork do
    cmd = row["command"]

    stdout, stderr, status = Open3.capture3(cmd)
    puts status

    stdout = clean(stdout)
    stderr = clean(stderr)

    # map stdout to the correct column
    txt = (row["output_type"] == "text") ? stdout : nil
    jsn = (row["output_type"] == "json") ? stdout : nil
    xml = (row["output_type"] == "xml")  ? stdout : nil

    # insert
    begin
      pg = PG.connect()
      pg.exec(%{
        INSERT INTO metrics
        (hostname, cmd, status, stderr, txt, jsn, xml)
        VALUES ($1, $2, $3, $4, $5, $6, $7);
    }, [hostname, cmd, status.exitstatus, stderr, txt, jsn, xml])
    ensure
      puts "pg.close"
      pg.close
    end
  end
end

Process.waitall
sleep 1
