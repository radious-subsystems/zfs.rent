const fs = require("fs");
const {Pool} = require("pg");
const pool = new Pool();

// register routes
module.exports = app => {
  app.get("/session_details", session_details);
}

async function session_details(req, res) {
  const query = `
    SELECT
      s.id as web_session_id,
      (CURRENT_TIMESTAMP > s.expires_at) as is_web_session_expired,
      (EXTRACT(EPOCH FROM
        (s.expires_at - current_timestamp))::REAL/3600
      )::NUMERIC(9,2) as web_session_hours_left,
      u.api_key,
      u.uid as user_id,
      u.email as user_email,
      u.is_onboarded as is_user_onboarded,
      u.created_at as user_created_at
    FROM login_session as s
      JOIN user_ as u
      USING(uid)
    WHERE s.id = $1
  `;
  const row = (await pool.query(query, [req.query.session_id])).rows[0];
  res.json(row);
}
