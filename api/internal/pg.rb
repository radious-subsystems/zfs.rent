require "pg"

PG_URL="REDACTED"

def pg_exec(query, params=[])
    pg  = PG.connect(PG_URL)
    res = pg.exec(query, params).to_a
    return res
end

