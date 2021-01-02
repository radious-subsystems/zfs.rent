#!/usr/bin/env node

const {readFiles, uts} = require("./lib/helpers");

(function usage() {
  const x = readFiles(["VERSION", "GIT_COMMIT_REF", "BUILD_DATE"]);
  console.log(`zz ${x.VERSION}-${x.GIT_COMMIT_REF}`);
  console.log(`build date: ${uts(x.BUILD_DATE)}\n`);
})();

const fetch = require("node-fetch");

(async function() {
  let res, jsn, m;

  console.log("bandwidth -> daily:");
  res = await fetch("https://zfs.rent/api/v0/user/bandwidth-daily");
  jsn = await res.json();
  m = jsn.map(x => ({[x.date]: {domain: x.domain, gb_consumed: parseFloat(x.gb_consumed)}}))
         .reduce((a,b,{}) => Object.assign(a, b));
  console.table(m);

  console.log("\nbandwidth -> monthly:");
  res = await fetch("https://zfs.rent/api/v0/user/bandwidth-monthly");
  jsn = await res.json();
  m = jsn.map(x => ({[x.month]: {domain: x.domain, gb_consumed: parseFloat(x.gb_consumed)}}))
         .reduce((a,b,{}) => Object.assign(a, b));
  console.table(m);

  console.log("\ndisk drives:");
  res = await fetch("https://zfs.rent/api/v0/user/disks");
  jsn = await res.json();
  console.table(jsn);
})()
