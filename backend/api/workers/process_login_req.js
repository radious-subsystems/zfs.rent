const {Pool} = require("pg");
const pool = new Pool();

const sendgrid = require("@sendgrid/mail");
sendgrid.setApiKey(process.env.SENDGRID_API_KEY)

async function main() {
  // retrieve login_req job from work queue
  const job = (await pool.query(`
    UPDATE work_queue
      SET locked_at = CURRENT_TIMESTAMP
      WHERE id IN (
        SELECT
          id
        FROM work_queue
        WHERE
          req_type = 'login_req'
          AND (CURRENT_TIMESTAMP < expires_at) -- not expired
          AND NOT g_is_locked
          AND NOT g_is_done
        LIMIT 1
      )
      RETURNING id, req_json;
  `)).rows[0];

  // no job --> exit
  if (job == undefined) return;

  console.log(job);
  const email = job.req_json.email;

  // check for existing user account
  let user = (await pool.query(`
    SELECT * FROM user_ WHERE email = $1;
  `, [email])).rows[0];
  console.log({user});

  // user does not exist --> create a new user
  if (user == undefined) {
    user = (await pool.query(`
      INSERT INTO user_ (email) VALUES ($1)
      RETURNING *;
    `, [email])).rows[0];
    console.log({user});
  }

  // now that we have a valid user --> create a login_session id
  const session = (await pool.query(`
    INSERT INTO login_session (uid) VALUES ($1)
    RETURNING *;
  `, [user.uid])).rows[0];
  console.log({session});

  // sendgrid enqueue: email session link to user's email
  nq_email({
    to: user.email,
    subject: "zfs.rent // login token",
    body: `https://zfs.rent/session?id=${session.id}`
  });

  // mark job as complete
  const job_done = (await pool.query(`
    UPDATE work_queue
      SET done_at = CURRENT_TIMESTAMP
      WHERE id = $1
    RETURNING *;
  `, [job.id])).rows[0];
  console.log({job_done});
}

async function nq_email(payload) {
  const query = `
    INSERT INTO work_queue (req_type, req_json)
    VALUES ('sendgrid_send_email', $1);
  `;
  const req_json = JSON.stringify(payload);
  await pool.query(query, [req_json]);
}

const process_sg = async function() {
  // retrieve sendgrid job from work queue
  const job = (await pool.query(`
    UPDATE work_queue
      SET locked_at = CURRENT_TIMESTAMP
      WHERE id IN (
        SELECT
          id
        FROM work_queue
        WHERE
          req_type = 'sendgrid_send_email'
          AND (CURRENT_TIMESTAMP < expires_at) -- not expired
          AND NOT g_is_locked
          AND NOT g_is_done
        LIMIT 1
      )
      RETURNING id, req_json;
  `)).rows[0];

  // no job --> exit
  if (job == undefined) return;

  // send email
  const msg = {
    to:      job.req_json.to,
    from:    "zfs@radious.co",
    subject: job.req_json.subject,
    text:    job.req_json.body
  };
  console.log({msg});
  const res = await sendgrid.send(msg);

  // mark job as complete
  const job_done = (await pool.query(`
    UPDATE work_queue
      SET done_at = CURRENT_TIMESTAMP
      WHERE id = $1
    RETURNING *;
  `, [job.id])).rows[0];
  console.log({job_done});
}

main().then(process_sg);
