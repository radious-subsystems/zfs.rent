const {Pool} = require("pg");
const pool = new Pool(connectionString: process.env.PG_URL);

module.exports = async function pg_netlify_functions_log(event, context) {
  console.log(event, context);
  const res = await pool.query(`
    INSERT INTO netlify_functions_log (event, context)
    VALUES ($1, $2);`, [JSON.stringify(event), JSON.stringify(context)]);
  console.log(res);
};
