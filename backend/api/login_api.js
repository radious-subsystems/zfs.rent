const fs = require("fs");
const {Pool} = require("pg");
const pool = new Pool();

// register routes
module.exports = app => {
  app.post("/login",   login_req);
}

// account login
async function login_req(req, res) {
  console.log(req.body);
  const email = req.body.email;

  if (email == null) {
    res.status(400).send(`error: invalid email: ${email}`);
    return;
  }

  try {
    await enqueue_login_req(email);
    res.send("login request received. please check your email.");
  } catch (e) {
    console.error(e);
    res.status(500).send("error: unable to queue login request.");
  }
};

async function enqueue_login_req(email) {
  const query = `
    INSERT INTO work_queue (req_type, req_json)
    VALUES ('login_req', $1);
  `;
  const req_json = JSON.stringify({email});
  await pool.query(query, [req_json]);
}
