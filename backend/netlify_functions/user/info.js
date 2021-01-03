const {Pool} = require("pg");
const pool = new Pool({connectionString: process.env.PG_URL});

exports.handler = async function (event, context) {
  // Grab user info
  const ip = event["headers"]["client-ip"];
  console.log(ip);
  const query = `SELECT * FROM dhcp_src WHERE ip = $1`;
  const rows = await pool.query(query, [ip])
    .then(res => res.rows[0])
    .catch(e => String(e));

  return {
    statusCode: 200,
    headers: {'content-type': 'application/json'},
    body: JSON.stringify({...rows, git: process.env.COMMIT_REF})
  };
}
