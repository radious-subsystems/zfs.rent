const {Pool} = require("pg");
const pool = new Pool({connectionString: process.env.PG_URL});

exports.handler = async function (event, context) {
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

  // fetch monthly bandwidth report
  const rows = (await pool.query(`
    SELECT
      to_char(created_at, 'YYYY-MM') as month,
      domain,
      sum(gb_consumed) gb_consumed
    FROM _user_bandwidth
    WHERE domain = $1
    GROUP BY 1, 2
    ORDER BY domain;
  `, [domain])).rows;

  return {
    statusCode: 200,
    headers: {'content-type': 'application/json'},
    body: JSON.stringify(rows)
  };
}
