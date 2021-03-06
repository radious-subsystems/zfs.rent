const {pg_netlify_functions_log} = require("../lib/helper"); 

const fs   = require("fs");
const path = require("path");

// ugh. we have to use this root require
// in order for netlify to bundle correctly
const pg = require("pg");

exports.handler = async function (event, context) {
  pg_netlify_functions_log(event, context);

  const parts   = event.path.split('/');
  const subPath = parts[parts.length-1];

  // subpath not implemented --> 404
  const js = `./${subPath}.js`;
  if (!fs.existsSync(path.join(__dirname, js)))
    return {statusCode: 404, body: '/user not implemented'};

  // otherwise, include and execute the subpath
  return (require(js)).handler(event, context);
}
