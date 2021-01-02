const {pg_netlify_functions_log} = require("./lib/helper"); 

exports.handler = async function (event, context) {
  pg_netlify_functions_log(event, context);
  console.log(event);

  return {
    statusCode: 200,
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(event)
  };
}
