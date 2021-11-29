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

def log_journal(pg, line_count: 10)
  rows  = []
  lines = `journalctl --output json --reverse --lines=#{line_count}`

  lines.each_line do |content|
    data = JSON.parse(content)
    id   = data["_BOOT_ID"] + data["__REALTIME_TIMESTAMP"]

    rows << [id, content]
  end

  query = %{
    INSERT INTO journal
    (id, content)
    VALUES
    #{params(rows: rows.length, columns: rows[0].length)}
    ON CONFLICT DO NOTHING
    RETURNING ts, id;
  }

  res = pg.exec(query, rows.flatten)
  puts res.to_a
end
