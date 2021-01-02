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

  res = await fetch("https://zfs.rent/api/v0/user/bandwidth-daily");
  jsn = await res.json();
  if (jsn.error) {
    console.error(jsn);
    return 1;
  }
  m = jsn.map(x => ({[x.date]: {domain: x.domain, gb_consumed: parseFloat(x.gb_consumed)}}))
         .reduce((a,b,{}) => Object.assign(a, b));
  console.log("bandwidth -> daily:");
  console.table(m);

  res = await fetch("https://zfs.rent/api/v0/user/bandwidth-monthly");
  jsn = await res.json();
  m = jsn.map(x => ({[x.month]: {domain: x.domain, gb_consumed: parseFloat(x.gb_consumed)}}))
         .reduce((a,b,{}) => Object.assign(a, b));
  console.log("\nbandwidth -> monthly:");
  console.table(m);

  res = await fetch("https://zfs.rent/api/v0/user/disks");
  jsn = await res.json();
  console.log("\ndisk drives:");
  console.table(jsn);
})()
