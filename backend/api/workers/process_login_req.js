const {Pool} = require("pg");
const pool = new Pool();

async function main() {
  const rows = (await pool.query(`
    SELECT
      ts, req_type, req_json,
      locked_at, done_at
    FROM work_queue
    WHERE
      req_type = 'sendgrid_login_req'
      AND (CURRENT_TIMESTAMP < expires_at) -- not expired
      AND NOT g_is_locked
      AND NOT g_is_done
  `)).rows;
  
  console.table(rows);
}

main();
