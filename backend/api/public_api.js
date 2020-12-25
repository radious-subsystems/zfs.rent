const fs = require("fs");
const {Pool} = require("pg");
const pool = new Pool();

// register routes
module.exports = app => {
  app.get("/v0/status/drives/hvm1.json",    hvm1_drives);
  app.get("/v0/status/bandwidth/hvm1.json", hvm1_bw);
}

// live drive temps
async function hvm1_drives(req, res) {
  const rows = (await pool.query(fs.readFileSync("drives.sql", "utf-8"))).rows;
  console.table(rows);
  res.json(rows);
}

// total bandwidth usage grouped by day
async function hvm1_bw(req, res) {
  const rows = (await pool.query(fs.readFileSync("bw.sql", "utf-8"))).rows;
  console.table(rows);
  res.json(rows);
}
