const {Pool} = require("pg");
const pool = new Pool({connectionString: process.env.PG_URL});

module.exports.pg_netlify_functions_log = async function(event, context) {
  console.log(event, context);
  const res = await pool.query(`
    INSERT INTO netlify_functions_log (event, context)
    VALUES ($1, $2);`, [JSON.stringify(event), JSON.stringify(context)]);
  console.log(res);
};
