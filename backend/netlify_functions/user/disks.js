const {Pool} = require("pg");
const pool = new Pool({connectionString: process.env.PG_URL});
const {pg_netlify_functions_log} = require("../lib/helper"); 

exports.handler = async function (event, context) {
  pg_netlify_functions_log(event, context);

  // Grab ip --> domain
  const ip = event["headers"]["client-ip"];
  console.log(ip);
  const query = `SELECT * FROM dhcp_src WHERE ip = $1`;
  const row = await pool.query(query, [ip])
    .then(res => res.rows[0])
    .catch(e => String(e));

  // validate domain name
  if (!row || !row.domain) {
    return {
      statusCode: 401,
      headers: {'content-type': 'application/json'},
      body: JSON.stringify({error: 'unknown user', ip, hint: 'are you behind a vpn?'})
    };
  }

  const domain = row.domain;

  // fetch disk drive temps
  const rows = (await pool.query(`
    select
      domain,
      split_part(model, ' ', 1) as brand,
      serial,
      sampled_at,
      temp_c
    from _user_disk_status
    where domain = $1
  `, [domain])).rows;

  return {
    statusCode: 200,
    headers: {'content-type': 'application/json'},
    body: JSON.stringify(rows)
  };
}
