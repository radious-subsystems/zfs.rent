require "json"

def params(rows: nil, columns: nil)
  x = (0..(rows-1)).map do |i|
    y = (1..columns).map do |j|
      "$#{j + i*columns}"
    end

    "(#{y.join(",")})"
  end

  return x.join(",\n")
end

def log_journal(pg, line_count: 100)
  rows  = []
  lines = `journalctl --output json --reverse --lines=#{line_count}`

  lines.each_line do |content|
    data = JSON.parse(content)

    boot_id = data["_BOOT_ID"]
    ts      = Time.at(data["__REALTIME_TIMESTAMP"].to_i / 1e6)

    rows << [ts, boot_id, content]
  end

  query = %{
    INSERT INTO journal_ht
    (ts, boot_id, content)
    VALUES
    #{params(rows: rows.length, columns: rows[0].length)}
    ON CONFLICT DO NOTHING
    RETURNING ts, boot_id;
  }

  res = pg.exec(query, rows.flatten)
  puts "table journal_ht: inserted #{res.to_a.count} rows."
end
