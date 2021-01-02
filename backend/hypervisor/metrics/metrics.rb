#!/usr/bin/env ruby

require "pg"
require "open3"

pg = PG.connect()
rows = pg.exec(%{SELECT * FROM metrics_cmd}).to_a

rows.each do |row|
    # fork and execute command --> insert to postgres
    pid = fork do
        cmd = row["command"]
        stdout, stderr, status = Open3.capture3(cmd)
        puts status

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
            }, [`echo $HOSTNAME`, cmd, status, stderr, txt, jsn, xml])
        ensure
            puts "pg.close"
            pg.close
        end
    end
end

Process.wait
sleep 1
