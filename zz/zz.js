#!/usr/bin/env node

const {readFiles, uts} = require("./lib/helpers");

(function usage() {
  const x = readFiles(["VERSION", "GIT_COMMIT_REF", "BUILD_DATE"]);
  console.log(`zz ${x.VERSION}-${x.GIT_COMMIT_REF}`);
  console.log(`build date: ${uts(x.BUILD_DATE)}\n`);
})();

const fetch = require("node-fetch");

(async function() {
  const res = await fetch("https://zfs.rent/api/v0/user/bandwidth_monthly");
  const jsn = await res.json();
  console.log(jsn);
})()
