const fs = require("fs");
const {Pool} = require("pg");
const pool = new Pool();

// register routes
module.exports = app => {
  app.post("/session_details", session_details);
}

async function session_details(req, res) {
  const query = `
    SELECT
      s.id as web_session_id,
      (CURRENT_TIMESTAMP > s.expires_at) as is_web_session_expired,
      (s.expires_at - current_timestamp) as web_session_expires_in,
      u.api_key,
      u.uid,
      u.email
    FROM login_session as s
      JOIN user_ as u
      USING(uid)
    WHERE s.id = $1
  `;
  const row = (await pool.query(query, [req.body.session_id])).rows[0];
  res.json({row});
}
