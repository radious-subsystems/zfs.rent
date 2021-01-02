const {Pool} = require("pg");
const pool = new Pool({connectionString: process.env.pg_url});

exports.handler = async function (event, context) {
  let res;
  try {
    res = (await pool.query('select version()')).rows[0];
  } catch (e) {
    res = String(e);
  }

  return {
    statusCode: 200,
    headers: {'content-type': 'application/json'},
    body: JSON.stringify({res, git: process.env.COMMIT_REF})
  };
}
