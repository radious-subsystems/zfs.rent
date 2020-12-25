const {Pool} = require("pg");
const pool = new Pool();

// register routes
module.exports = app => {
  app.post("/login", login_req);
}

async function main() {
  const rows = await pool.query(`
    SELECT *
    FROM work_queue
    WHERE req_type = 'sendgrid_login_req'
  `).rows;
  
  console.table(rows);
}

main();
